import 'package:flutter/material.dart';
import '../utils/dimensions.dart';
import '../utils/styles.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        maintainBottomViewPadding: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: Dimen.regularPadding,
                child: Text(
                  'Welcome to SUConnect',
                  style: kHeadingTextStyle,
                ),
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(60.0),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(
                  'https://giftstrefa.pl/wp-content/uploads/2020/01/vodka-connecting-people-kubek.jpg',
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Signup',
                          style: kButtonLightTextStyle,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Login',
                          style: kButtonLightTextStyle,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
