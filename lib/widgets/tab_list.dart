import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabList extends StatelessWidget {
  TabList();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: TappableTravelDestinationItem(),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: TappableTravelDestinationItem(),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: TappableTravelDestinationItem(),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: TappableTravelDestinationItem(),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: TappableTravelDestinationItem(),
          ),
        ],
      ),
    );
  }
}

class TappableTravelDestinationItem extends StatelessWidget {
  const TappableTravelDestinationItem({Key key, this.shape}) : super(key: key);

  // This height will allow for all the Card's content to fit comfortably within the card.
  static const height = 298.0;

  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: height,
              child: Card(
                // This ensures that the Card's children (including the ink splash) are clipped correctly.
                clipBehavior: Clip.antiAlias,
                shape: shape,
                child: InkWell(
                  onTap: () {
                    print('Card was tapped');
                  },
                  // Generally, material cards use onSurface with 12% opacity for the pressed state.
                  splashColor:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                  // Generally, material cards do not have a highlight overlay.
                  highlightColor: Colors.transparent,
                  child: TravelDestinationContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TravelDestinationContent extends StatelessWidget {
  const TravelDestinationContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.headline5.copyWith(color: Colors.white);
    final descriptionStyle = theme.textTheme.subtitle1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 184,
          child: Stack(
            children: [
              Positioned.fill(
                // In order to have the ink splash appear above the image, you
                // must use Ink.image. This allows the image to be painted as
                // part of the Material and display ink effects above it. Using
                // a standard Image will obscure the ink splash.
                child: Ink.image(
                  image: NetworkImage(
                      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg'),
                  fit: BoxFit.cover,
                  child: Container(),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'destination',
                    style: titleStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Description and share/explore buttons.
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: DefaultTextStyle(
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: descriptionStyle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // This array contains the three line description on each card
                // demo.
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'destination.description',
                    style: descriptionStyle.copyWith(color: Colors.black54),
                  ),
                ),
                Text('destination.city'),
                Text('destination.location'),
              ],
            ),
          ),
        ),

        // share, explore buttons
        // ButtonBar(
        //   alignment: MainAxisAlignment.start,
        //   children: [
        //     RaisedButton(
        //       child: Text('destination.title'),
        //       onPressed: () {
        //         print('pressed');
        //       },
        //     ),
        //     RaisedButton(
        //       child: Text('destination.title'),
        //       onPressed: () {
        //         print('pressed');
        //       },
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
