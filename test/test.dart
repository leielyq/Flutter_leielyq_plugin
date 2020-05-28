import 'package:flutter_leielyq_plugin/http/HttpUtil.dart';
import 'package:flutter_test/flutter_test.dart';

main(){
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
//    await tester.pumpWidget(MyApp());/**/
    var string = "foo,bar,baz";
    expect(string.split(","), equals(["foo", "bar", "baz"]));

    print('123');

    Future<dynamic> str =  HttpUtil.instance.postAwait('http://192.168.0.111:8080/TChat/circle/video_find');
    print(str);
  });
}