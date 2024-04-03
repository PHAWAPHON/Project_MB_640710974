import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../apiService1.dart';
import '../model/player.dart';
import 'package:google_fonts/google_fonts.dart';
import '../tabbar/customtabbar.dart';

class Players extends StatefulWidget {
  const Players({Key? key}) : super(key: key);

  @override
  _PlayersState createState() => _PlayersState();
}

class _PlayersState extends State<Players> {
  int _current = 0;
  final CarouselController _carouselController = CarouselController();
  TopScorer? _selectedIndex;
  List<TopScorer>? _players;
  int currentTabIndex = 0;
  final List<int> leagueNumbers = [39, 140, 78, 135, 61];
  String currentTop = "topscorers";
  int _bottomIndex = 0;
  @override
  @override
  void initState() {
    super.initState();
    _fetchData("topscorers", leagueNumbers[currentTabIndex]);
  }

  void _fetchData(String tops, int leagueNumber) async {
    try {
      List<TopScorer> data =
          await FootballApiService().getTop(tops, leagueNumber);
      setState(() {
        _players = data;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Widget buildCarousel(BuildContext context) {
    if (_players == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: CarouselSlider(
        carouselController: _carouselController,
        options: CarouselOptions(
          height: 400.0,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
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
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: _selectedIndex == topScorer
                        ? Border.all(
                            color: Theme.of(context).primaryColor, width: 3)
                        : Border.all(color: Colors.transparent),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Rank: ${_players!.indexOf(topScorer) + 1}',
                          style: GoogleFonts.lato(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[900],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: Image.network(
                            topScorer.player.photo,
                            fit: BoxFit.contain,
                            width: MediaQuery.of(context).size.width * 0.7,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          topScorer.player.name,
                          style: GoogleFonts.lato(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[900],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          topScorer.statistics.first.team.name,
                          style: GoogleFonts.lato(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[900],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          currentTop == "topscorers"
                              ? 'Score: ${topScorer.statistics.first.goals.total}'
                              : 'Assists: ${topScorer.statistics.first.goals.assists}', 
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            color: Colors.pink[900],
                          ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTabBar(
            items: [
              'Premier League',
              'LaLiga',
              'Bundesliga',
              'Serie A',
              'Ligue 1',
            ],
            onTabChanged: (index) {
              setState(() {
                currentTabIndex = index;
                _fetchData(currentTop, leagueNumbers[index]);
              });
            },
          ),
          Expanded(
            child: buildCarousel(context),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.purple,
        selectedItemColor: Colors.pink,
        currentIndex: _bottomIndex, 
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Top Scorers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_neutral),
            label: 'Top Assists',
          ),
        ],
        onTap: (index) {
          setState(() {
            _bottomIndex = index;
            currentTop = (index == 0) ? "topscorers" : "topassists";
            _fetchData(currentTop, leagueNumbers[currentTabIndex]);
          });
        },
      ),
      floatingActionButton: _selectedIndex != null
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
              backgroundColor: Theme.of(context).primaryColor,
            )
          : null,
    );
  }
}
