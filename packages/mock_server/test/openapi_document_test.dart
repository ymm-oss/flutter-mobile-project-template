import 'package:internal_mock_server/internal_mock_server.dart';
import 'package:test/test.dart';

void main() {
  /// [responses] を `GET /items` の応答に持つ仕様書を読み、その応答を返す。
  MockResponse responseOf(String responses, {String components = ''}) {
    final document = OpenApiDocument.parse('''
openapi: 3.0.3
info:
  title: Test
  version: 1.0.0
paths:
  /items:
    get:
      responses:
$responses
$components
''');
    return document.operations.single.response;
  }

  group('OpenApiDocument.parse', () {
    test('パスとメソッドごとに operation を読む', () {
      final document = OpenApiDocument.parse('''
openapi: 3.0.3
info:
  title: Test
  version: 1.0.0
paths:
  /items:
    get:
      operationId: listItems
      responses:
        "204":
          description: ok
    post:
      responses:
        "204":
          description: ok
''');

      expect(
        document.operations.map((operation) => operation.label),
        ['GET /items (listItems)', 'POST /items'],
      );
    });

    test('paths がなければ FormatException を投げる', () {
      expect(
        () => OpenApiDocument.parse('openapi: 3.0.3'),
        throwsFormatException,
      );
    });

    test('YAML として読めなければ FormatException を投げる', () {
      expect(() => OpenApiDocument.parse('paths: ['), throwsFormatException);
    });

    test('中身を読めないパスは読み飛ばし、skippedPaths に入れる', () {
      final document = OpenApiDocument.parse(r'''
paths:
  x-extension: value
  /items:
    $ref: ./paths/items.yaml
  /drafts:
    get:
      responses:
        "204":
          description: ok
''');

      expect(document.skippedPaths, ['/items']);
      expect(document.operations.map((operation) => operation.path), [
        '/drafts',
      ]);
    });
  });

  group('OpenApiDocument.basePath', () {
    String basePathOf(String servers) =>
        OpenApiDocument.parse('$servers\npaths: {}').basePath;

    test('servers の 1 つ目の URL のパスを返す', () {
      expect(
        basePathOf('''
servers:
  - url: https://api.example.com/v1/
  - url: https://staging.example.com/v2
'''),
        '/v1',
      );
    });

    test('URL の変数を default の値で埋める', () {
      expect(
        basePathOf('''
servers:
  - url: https://{env}.example.com/{version}
    variables:
      env:
        default: api
      version:
        default: v2
'''),
        '/v2',
      );
    });

    test('ホストのない URL のパスも返す', () {
      expect(basePathOf('servers: [{url: /api/v1}]'), '/api/v1');
    });

    test('servers がないときと、URL のパスが / のときは空文字を返す', () {
      expect(basePathOf(''), '');
      expect(basePathOf('servers: [{url: "https://api.example.com/"}]'), '');
    });

    test('URL の変数に default がなければ FormatException を投げる', () {
      expect(
        () => basePathOf('servers: [{url: "https://api.example.com/{v}"}]'),
        throwsFormatException,
      );
    });
  });

  group('example の探し方', () {
    test('media type の example を返す', () {
      final response = responseOf('''
        "200":
          description: ok
          content:
            application/json:
              example:
                id: "1"
              examples:
                other:
                  value:
                    id: "2"
''');

      expect(
        response,
        isA<ExampleResponse>()
            .having((r) => r.statusCode, 'statusCode', 200)
            .having(
              (r) => r.contentType,
              'contentType',
              'application/json; charset=utf-8',
            )
            .having((r) => r.body, 'body', '{"id":"1"}'),
      );
    });

    test('example がなければ examples の最初の value を返す', () {
      final response = responseOf('''
        "200":
          description: ok
          content:
            application/json:
              examples:
                first:
                  value:
                    id: "1"
                second:
                  value:
                    id: "2"
''');

      expect(
        response,
        isA<ExampleResponse>().having((r) => r.body, 'body', '{"id":"1"}'),
      );
    });

    test('media type になければ schema の example を返す', () {
      final response = responseOf('''
        "200":
          description: ok
          content:
            application/json:
              schema:
                type: object
                example:
                  id: "1"
''');

      expect(
        response,
        isA<ExampleResponse>().having((r) => r.body, 'body', '{"id":"1"}'),
      );
    });

    test(r'応答、examples、schema の $ref を解決する', () {
      final response = responseOf(
        r'''
        "200":
          $ref: "#/components/responses/Item"
''',
        components: r'''
components:
  responses:
    Item:
      description: ok
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/Item"
  schemas:
    Item:
      type: object
      example:
        id: "1"
''',
      );

      expect(
        response,
        isA<ExampleResponse>().having((r) => r.body, 'body', '{"id":"1"}'),
      );
    });

    test('schema に example がなければ、schema の examples の最初の値を返す', () {
      final response = responseOf('''
        "200":
          description: ok
          content:
            application/json:
              schema:
                type: object
                examples:
                  - id: "1"
                  - id: "2"
''');

      expect(
        response,
        isA<ExampleResponse>().having((r) => r.body, 'body', '{"id":"1"}'),
      );
    });

    test('JSON で表せない数を含む example は MissingExample を返す', () {
      final response = responseOf('''
        "200":
          description: ok
          content:
            application/json:
              example:
                value: .nan
''');

      expect(
        response,
        isA<MissingExample>().having(
          (r) => r.reason,
          'reason',
          contains('NaN か Infinity があり、JSON で表せません。'),
        ),
      );
    });

    test('JSON でない media type では、NaN の数も文字列にして返す', () {
      final response = responseOf('''
        "200":
          description: ok
          content:
            text/plain:
              example: .nan
''');

      expect(
        response,
        isA<ExampleResponse>().having((r) => r.body, 'body', 'NaN'),
      );
    });

    test('JSON でない media type でオブジェクトの example は MissingExample を返す', () {
      final response = responseOf('''
        "200":
          description: ok
          content:
            application/xml:
              example:
                id: "1"
''');

      expect(
        response,
        isA<MissingExample>().having(
          (r) => r.reason,
          'reason',
          contains('オブジェクトか配列のため、本文にできません。'),
        ),
      );
    });

    test(r'schema の $ref を読めなければ、そのことを理由に書く', () {
      final response = responseOf(r'''
        "200":
          description: ok
          content:
            application/json:
              schema:
                $ref: ./schemas/Item.yaml
''');

      expect(
        response,
        isA<MissingExample>().having(
          (r) => r.reason,
          'reason',
          contains(r'GET /items の 200 の応答（application/json）の $ref を読めません。'),
        ),
      );
    });

    test(r'パーセントエンコードが正しくない $ref は MissingExample を返す', () {
      final response = responseOf(r'''
        "200":
          $ref: "#/components/responses/100%"
''');

      expect(response, isA<MissingExample>());
    });

    test('example の値が null でも見つかったものとして扱う', () {
      final response = responseOf('''
        "200":
          description: ok
          content:
            application/json:
              example: null
''');

      expect(
        response,
        isA<ExampleResponse>().having((r) => r.body, 'body', 'null'),
      );
    });

    test('example がなければ MissingExample を返す', () {
      final response = responseOf('''
        "200":
          description: ok
          content:
            application/json:
              schema:
                type: object
''');

      expect(
        response,
        isA<MissingExample>().having(
          (r) => r.reason,
          'reason',
          contains('GET /items の 200 の応答（application/json）に example がありません。'),
        ),
      );
    });

    test(r'循環した $ref は MissingExample を返す', () {
      final response = responseOf(
        r'''
        "200":
          $ref: "#/components/responses/A"
''',
        components: r'''
components:
  responses:
    A:
      $ref: "#/components/responses/B"
    B:
      $ref: "#/components/responses/A"
''',
      );

      expect(
        response,
        isA<MissingExample>().having(
          (r) => r.reason,
          'reason',
          r'GET /items の 200 の応答を読めません。$ref の参照先を確かめてください。',
        ),
      );
    });
  });

  group('応答の選び方', () {
    test('2xx のうち最も小さいコードを選ぶ', () {
      final response = responseOf('''
        "404":
          description: not found
        "201":
          description: created
        "200":
          description: ok
''');

      expect(
        response,
        isA<ExampleResponse>().having((r) => r.statusCode, 'statusCode', 200),
      );
    });

    test('2xx がなければ default を 200 で返す', () {
      final response = responseOf('''
        default:
          description: ok
          content:
            application/json:
              example:
                id: "1"
''');

      expect(
        response,
        isA<ExampleResponse>()
            .having((r) => r.statusCode, 'statusCode', 200)
            .having((r) => r.body, 'body', '{"id":"1"}'),
      );
    });

    test('2XX を default より先に書いていなくても、2XX を選ぶ', () {
      final response = responseOf('''
        default:
          description: error
          content:
            application/json:
              example:
                message: error
        2XX:
          description: ok
          content:
            application/json:
              example:
                id: "1"
''');

      expect(
        response,
        isA<ExampleResponse>().having((r) => r.body, 'body', '{"id":"1"}'),
      );
    });

    test('2xx も default もなければ MissingExample を返す', () {
      final response = responseOf('''
        "404":
          description: not found
''');

      expect(
        response,
        isA<MissingExample>().having(
          (r) => r.reason,
          'reason',
          'GET /items に 2xx と default の応答がありません。',
        ),
      );
    });

    test('content がなければ本文のない応答を返す', () {
      final response = responseOf('''
        "204":
          description: no content
''');

      expect(
        response,
        isA<ExampleResponse>()
            .having((r) => r.statusCode, 'statusCode', 204)
            .having((r) => r.contentType, 'contentType', isNull)
            .having((r) => r.body, 'body', isNull),
      );
    });

    test('media type は JSON 系を優先し、JSON でない文字列はそのまま返す', () {
      final json = responseOf('''
        "200":
          description: ok
          content:
            text/plain:
              example: text
            application/problem+json:
              example:
                id: "1"
''');
      final text = responseOf('''
        "200":
          description: ok
          content:
            text/plain:
              example: text
''');

      expect(
        json,
        isA<ExampleResponse>()
            .having(
              (r) => r.contentType,
              'contentType',
              'application/problem+json; charset=utf-8',
            )
            .having((r) => r.body, 'body', '{"id":"1"}'),
      );
      expect(
        text,
        isA<ExampleResponse>()
            .having((r) => r.contentType, 'contentType', 'text/plain')
            .having((r) => r.body, 'body', 'text'),
      );
    });

    test('*/* の media type では、本文に合わせた Content-Type にする', () {
      MockResponse wildcardOf(String example) => responseOf('''
        "200":
          description: ok
          content:
            "*/*":
              example: $example
''');

      expect(
        wildcardOf('{id: "1"}'),
        isA<ExampleResponse>()
            .having(
              (r) => r.contentType,
              'contentType',
              'application/json; charset=utf-8',
            )
            .having((r) => r.body, 'body', '{"id":"1"}'),
      );
      expect(
        wildcardOf('text'),
        isA<ExampleResponse>()
            .having(
              (r) => r.contentType,
              'contentType',
              'text/plain; charset=utf-8',
            )
            .having((r) => r.body, 'body', 'text'),
      );
    });
  });
}
