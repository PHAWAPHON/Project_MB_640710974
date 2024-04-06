import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> items;

  final Function(int) onTabChanged;

  const CustomTabBar({
    Key? key,
    required this.items,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Container( 
      height: 50, 
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: widget.items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    current = index;
                  });
                  widget.onTabChanged(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.all(5),
                  width: 130,
                  height: 30,
                  decoration: BoxDecoration(
                    color: current == index ? Colors.pink : Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.pink,
                      width: 2.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.items[index],
                      style: GoogleFonts.ubuntu(
                        fontWeight: FontWeight.w500,
                        color: current == index
                            ? Colors.white
                            : Colors.pink,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: current == index,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                      color: Colors.pink, shape: BoxShape.circle),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
