import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../apiService1.dart'; // Make sure this has the getTopScorers method
import '../model/player.dart'; // Make sure this has the TopScorer and Player class definitions

class Players extends StatefulWidget {
  const Players({Key? key}) : super(key: key);

  @override
  _PlayersState createState() => _PlayersState();
}

class _PlayersState extends State<Players> {
  int _current = 0;
  final CarouselController _carouselController = CarouselController();
  TopScorer? _selectedIndex;
  bool startAnimation = false;
  List<TopScorer>? _players;

  @override
  void initState() {
    super.initState();
    _fetchTopScorers();
  }

  void _fetchTopScorers() async {
    try {
      List<TopScorer> topScorers = await FootballApiService().getTopScorers(39); // Replace with your league number
      setState(() {
        _players = topScorers;
      });
    } catch (e) {
      print("Error fetching top scorers: $e");
    }
  }

  Widget buildCarousel(BuildContext context) {
    if (_players == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return CarouselSlider(
      carouselController: _carouselController,
      options: CarouselOptions(
        height: 350.0,
        aspectRatio: 16 / 9,
        viewportFraction: 0.70,
        enlargeCenterPage: true,
        pageSnapping: true,
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        },
      ),
      items: _players!.map((topScorer) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = topScorer;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                transform: Matrix4.identity()
                  ..scale(_selectedIndex == topScorer ? 1.1 : 1.0),
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: _selectedIndex == topScorer
                      ? Border.all(color: Theme.of(context).primaryColor, width: 3)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Image.network(
                          topScorer.player.photo,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        topScorer.player.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Position: ${topScorer.statistics.first.games.position}', // Assuming we want the position from the first statistic
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Top Scorers',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: buildCarousel(context),
      floatingActionButton: _selectedIndex != null
          ? FloatingActionButton(
              onPressed: () {
                // Implement the onPressed logic
              },
              child: const Icon(Icons.arrow_forward_ios),
            )
          : null,
    );
  }
}
