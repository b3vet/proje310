import 'package:flutter/material.dart';

class FeedView extends StatelessWidget {
  const FeedView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return _postListView();
  }
}

Widget _authorView() {
  const double diameter = 30.0;
  return const CircleAvatar(
    radius: diameter,
    backgroundImage: NetworkImage(
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR63KoribGVDB_dswx8iUX99udIebJK_EsaYYTwg2vJoIeIECXhO8iWnI5VBU64wLJ-8gg&usqp=CAU"),
  );
}

Widget _postCaption() {
  return const Padding(
    padding: EdgeInsets.all(0),
    child: Text(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer dolor orci, maximus nec finibus vitae, laoreet vitae mauris. In blandit non velit vel pulvinar. Aenean ut leo justo. Praesent a diam eget sapien tempus hendrerit.',
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
    ),
  );
}

Widget _postImageView() {
  return Container(
    padding: EdgeInsets.only(top: 10.0),
    child: Image.network(
      "https://japonoloji.com/wp-content/uploads/2019/02/dororo-anime.jpg",
      fit: BoxFit.cover,
    ),
  );
}

Widget _viewCommentAndLikeButtons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        'View Comments',
        style: TextStyle(
            fontSize: 13.0, color: Colors.grey, fontWeight: FontWeight.w400),
      ),
      IconButton(
          onPressed: () => print("Liked"),
          icon: const Icon(
            Icons.thumb_up,
            color: Colors.grey,
          ))
    ],
  );
}

Widget _postView() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _authorView(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _postCaption(),
                _postImageView(),
                _viewCommentAndLikeButtons()
              ],
            ),
          ),
        )
      ],
    ),
  );
}

Widget _postListView() {
  return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return _postView();
      });
}