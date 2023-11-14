import 'package:flutter/material.dart';

const List<TrackGV> _items = [
  TrackGV(1, 1),
  TrackGV(2, 2),
  TrackGV(3, 3),
];

@immutable
class ExampleDragAndDrop extends StatefulWidget {
  const ExampleDragAndDrop({super.key});

  @override
  State<ExampleDragAndDrop> createState() => _ExampleDragAndDropState();
}

class _ExampleDragAndDropState extends State<ExampleDragAndDrop>
    with TickerProviderStateMixin {
  final List<TrackTmGV> _people = [
    TrackTmGV(),
    TrackTmGV(),
    TrackTmGV(),
  ];

  final GlobalKey _draggableKey = GlobalKey();

  void dropGV(TrackGV item, TrackTmGV track) {
    setState(() {
      track.items.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: _buildMenuList(),
                ),
                _buildPeopleRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 12,
        );
      },
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildMenuItem(
          item: item,
        );
      },
    );
  }

  Widget _buildMenuItem({
    required TrackGV item,
  }) {
    return LongPressDraggable<TrackGV>(
      data: item,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DraggingGV(
        dragKey: _draggableKey,
      ),
      child: GluVal2(item.str_price),
    );
  }

  Widget _buildPeopleRow() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 20,
      ),
      child: Row(
        children: _people.map(DropZone).toList(),
      ),
    );
  }

  Widget DropZone(TrackTmGV trackC) {
    return DragTarget<TrackGV>(
        builder: (context, candidateItems, rejectedItems) {
      return DataletGV(
        trackC,
        candidateItems.isNotEmpty,
        trackC.items.isNotEmpty,
      );
    }, onAccept: (item) {
      dropGV(
        item,
        trackC,
      );
    });
  }
}

class DataletGV extends StatelessWidget {
  TrackTmGV trackTmGV;
  bool highlighted;
  bool hasItems;
  DataletGV(this.trackTmGV, this.highlighted, this.hasItems);

  @override
  Widget build(BuildContext context) {
    final textColor = highlighted ? Colors.white : Colors.black;

    return Transform.scale(
        scale: highlighted ? 1.075 : 1.0,
        child: Container(
            width: 100,
            //elevation: highlighted ? 8 : 4,
            decoration: BoxDecoration(
                color: highlighted ? const Color(0xFFF64209) : Colors.white,
                borderRadius: BorderRadius.circular(22)),
            child: Visibility(
                visible: hasItems,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: SizedBox(
                    height: 60,
                    child: Text(trackTmGV.list_p,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ))))));
  }
}

class GluVal2 extends StatelessWidget {
  String gv = '';
  GluVal2(this.gv);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.all(Radius.circular(15))),
    ));
  }
}

class DraggingGV extends StatelessWidget {
  const DraggingGV({
    super.key,
    required this.dragKey,
  });

  final GlobalKey dragKey;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-1, -1),
      child: ClipRRect(
        key: dragKey,
        borderRadius: BorderRadius.circular(20),
        child: Container(width: 40, height: 40, color: Colors.red),
      ),
    );
  }
}

@immutable
class TrackGV {
  const TrackGV(
    this.gv,
    this.uid,
  );
  final int gv;
  final int uid;
  String get str_price => gv.toString();
}

class TrackTmGV {
  List<TrackGV> items = [];
  TrackTmGV();

  String get list_p {
    List<String> l = [];
    for (TrackGV i in items) {
      l.add(i.gv.toString());
    }
    return l.toString();
  }
}
