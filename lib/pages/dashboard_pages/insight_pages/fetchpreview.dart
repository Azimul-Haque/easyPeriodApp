import 'package:http/http.dart';
import 'package:html/parser.dart';

class FetchPreview {
  Future fetch(url) async {
    final client = Client();
    final response = await client.get(Uri.parse(url));
    final document = parse(response.body);

    String description, title, image, appleIcon, favIcon;

    var elements = document.getElementsByTagName('meta');
    final linkElements = document.getElementsByTagName('link');

    elements.forEach((tmp) {
      if (tmp.attributes['property'] == 'og:title') {
        title = tmp.attributes['content'];
      }

      if (title == null || title.isEmpty) {
        title = document.getElementsByTagName('title')[0].text;
      }

      if (tmp.attributes['property'] == 'og:description') {
        description = tmp.attributes['content'];
      }
      if (description == null || description.isEmpty) {
        //fetch base title
        if (tmp.attributes['name'] == 'description') {
          description = tmp.attributes['content'];
        }
      }

      //fetch image
      if (tmp.attributes['property'] == 'og:image') {
        image = tmp.attributes['content'];
      }
    });

    linkElements.forEach((tmp) {
      if (tmp.attributes['rel'] == 'apple-touch-icon') {
        appleIcon = tmp.attributes['href'];
      }
      if (tmp.attributes['rel']?.contains('icon') == true) {
        favIcon = tmp.attributes['href'];
      }
    });

    return {
      'title': title ?? '',
      'description': description ?? '',
      'image': image ??
          'https://tenxorg.com/images/blogs/how-to-manage-your-time-for-achieving-your-goals-1618900206.jpg',
      'appleIcon': appleIcon ?? '',
      'favIcon': favIcon ?? '',
      'url': url
    };
  }
}
