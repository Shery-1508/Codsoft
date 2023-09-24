import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favorites_screen.dart';

void main() {
  runApp(QuoteOfTheDayApp());
}

class QuoteOfTheDayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote of the Day',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.yellow[100],
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.orange),
      ),
      home: QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen>
    with SingleTickerProviderStateMixin {
  String _currentQuote = "Loading..."; // Initial quote
  String _authorName = ""; // Author's name
  List<dynamic> quotes = [];
  bool isFavorite = false; // Track favorite status
  List<int> _favoriteQuoteIndices = [];
  int _currentQuoteIndex = -1; // Index of the currently displayed quote

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
    loadQuotes();
    _getFavoriteQuoteIndices().then((value) {
      setState(() {
        _favoriteQuoteIndices = value;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animateQuoteChange() {
    _animationController.reset();
    _animationController.forward();
  }

  void updateDailyQuote() {
    final randomQuote = getRandomQuote();
    setState(() {
      _animateQuoteChange(); // Trigger fade animation
      _currentQuote = randomQuote['quote'];
      _authorName = "-" + randomQuote['author'];
      _currentQuoteIndex = quotes.indexOf(randomQuote);
      isFavorite = _favoriteQuoteIndices.contains(_currentQuoteIndex);
    });
  }

  void handleFavoritesCleared() {
    setState(() {
      _favoriteQuoteIndices
          .clear(); // Clear the liked quotes list in QuoteScreen
    });
  }

  Future<List<int>> _getFavoriteQuoteIndices() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteQuoteIndices = prefs.getStringList('favoriteQuoteIndices');
    if (favoriteQuoteIndices != null) {
      _favoriteQuoteIndices = favoriteQuoteIndices
          .map((indexStr) => int.tryParse(indexStr) ?? -1)
          .toList();
    }
    return _favoriteQuoteIndices;
  }

  Future<void> addToFavorites(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (!_favoriteQuoteIndices.contains(index)) {
        // If not a favorite, add the index
        _favoriteQuoteIndices.add(index);
        // Toggle the favorite status
        isFavorite = true;
      } else {
        // If already a favorite, remove it
        _favoriteQuoteIndices.remove(index);
        // Toggle the favorite status
        isFavorite = false;
      }
      // Update SharedPreferences with the list of indices
      prefs.setStringList('favoriteQuoteIndices',
          _favoriteQuoteIndices.map((index) => index.toString()).toList());
    });
  }

  // Function to get a random quote
  Map<String, dynamic> getRandomQuote() {
    final random = Random();
    final randomQuote = quotes[random.nextInt(quotes.length)];
    return randomQuote;
  }

  Future<void> loadQuotes() async {
    final String response = await rootBundle.loadString('assets/quotes.json');
    final data = await json.decode(response);
    setState(() {
      quotes = data['quotes'];
      updateDailyQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quote of the Day',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    onFavoritesCleared: handleFavoritesCleared,
                    favoriteQuoteIndices: _favoriteQuoteIndices,
                    quotes: quotes,
                    onQuoteDeleted: (index) {
                      setState(() {
                        _currentQuoteIndex = index;
                        if (_favoriteQuoteIndices.contains(index)) {
                          addToFavorites(index);
                        }
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // button to go to favorites screen with text "Favorites" and icon of a heart
            /// favorites screen button
            Column(
              children: [
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('Favorites'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoritesScreen(
                          onFavoritesCleared: handleFavoritesCleared,
                          favoriteQuoteIndices: _favoriteQuoteIndices,
                          quotes: quotes,
                          onQuoteDeleted: (index) {
                            setState(() {
                              _currentQuoteIndex = index;
                              if (_favoriteQuoteIndices.contains(index)) {
                                addToFavorites(index);
                              }
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            /// @Sheharyar
            Column(
              children: [
                Divider(
                  thickness: 2,
                ),
                Text('@Sheharyar'),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade200, Colors.blue.shade400],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// main quote container
                GestureDetector(
                  onDoubleTap: () {
                    addToFavorites(
                        _currentQuoteIndex); // Add the quote to favorites
                  },
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isFavorite ? Colors.red[100] : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),

                      /// quote text content
                      child: Column(
                        children: <Widget>[
                          /// "quote of the day" text
                          Center(
                            child: Text(
                              'Quote of the Day',
                              style: TextStyle(
                                fontFamily: 'Titling',
                                fontSize: 25,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),

                          /// quote text
                          Text(
                            _currentQuote,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black, // Text color
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),

                          /// author name
                          Text(
                            _authorName,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: isFavorite
                                  ? Colors.indigo
                                  : Colors.grey[700], // Text color
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                /// buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /// previous button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Button color
                      ),
                      onPressed: () {
                        setState(() {
                          if (_currentQuoteIndex > 0) {
                            _currentQuoteIndex--;
                          } else {
                            _currentQuoteIndex = quotes.length -
                                1; // Loop back to the last quote
                          }
                          _currentQuote = quotes[_currentQuoteIndex]['quote'];
                          _authorName =
                              "-" + quotes[_currentQuoteIndex]['author'];
                          isFavorite = _favoriteQuoteIndices
                              .contains(_currentQuoteIndex);
                          _animateQuoteChange(); // Trigger fade animation
                        });
                      },
                      child: Icon(Icons.skip_previous),
                    ),
                    SizedBox(
                      width: 10,
                    ),

                    /// random button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Button color
                      ),
                      onPressed: () {
                        updateDailyQuote();
                      },

                      /// (text) 🔀 Random
                      child: Row(
                        children: [
                          Icon(Icons.shuffle),
                          SizedBox(width: 5),
                          Text(
                            'Random',
                            style: TextStyle(
                              color: Colors.white, // Text color
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),

                    /// next button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Button color
                      ),
                      onPressed: () {
                        setState(() {
                          if (_currentQuoteIndex < quotes.length - 1) {
                            _currentQuoteIndex++;
                          } else {
                            _currentQuoteIndex =
                                0; // Loop back to the first quote
                          }
                          _currentQuote = quotes[_currentQuoteIndex]['quote'];
                          _authorName =
                              "-" + quotes[_currentQuoteIndex]['author'];
                          isFavorite = _favoriteQuoteIndices
                              .contains(_currentQuoteIndex);
                          _animateQuoteChange(); // Trigger fade animation
                        });
                      },
                      child: Icon(Icons.skip_next),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                /// favorite and share buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red, // Icon color
                      ),
                      onPressed: () {
                        addToFavorites(_currentQuoteIndex);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.white, // Icon color
                      ),
                      onPressed: () {
                        Share.share(
                            'Check out this quote:\n "$_currentQuote" - $_authorName \n @Sheharyar_QouteAPP_Codsoft');
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
