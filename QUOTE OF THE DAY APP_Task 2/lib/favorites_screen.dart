import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesScreen extends StatefulWidget {
  final List<int> favoriteQuoteIndices;
  final VoidCallback onFavoritesCleared;
  final List<dynamic> quotes;
  final Function(int) onQuoteDeleted;

  FavoritesScreen({
    required this.favoriteQuoteIndices,
    required this.onFavoritesCleared,
    required this.quotes,
    required this.onQuoteDeleted,
  });

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Future<void> _clearLikedQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('favoriteQuoteIndices');
    widget.onFavoritesCleared(); // Notify parent widget
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'All favorite quotes cleared.',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _removeQuote(int index) {
    final prefs = SharedPreferences.getInstance();
    final updatedIndices = [...widget.favoriteQuoteIndices];
    updatedIndices.remove(index);
    prefs.then((prefs) {
      prefs.setStringList(
          'favoriteQuoteIndices',
          updatedIndices
              .map((index) => index.toString())
              .toList()); // Update SharedPreferences
    });
    widget.onQuoteDeleted(index); // Notify parent widget
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Quote removed from favorites.',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _shareQuote(int index) {
    final favoriteQuoteIndex = widget.favoriteQuoteIndices[index];
    final favoriteQuote = widget.quotes[favoriteQuoteIndex]['quote'];
    final author = widget.quotes[favoriteQuoteIndex]['author'];
    Share.share(
        'Check out this quote:\n "$favoriteQuote" - $author \n @Sheharyar_QouteAPP_Codsoft');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Quotes',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              _clearLikedQuotes();
              setState(() {
                widget.favoriteQuoteIndices.clear();
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade200, Colors.blue.shade400],
          ),
        ),

        /// building the list of favorite quotes
        child: ListView.builder(
          // using the length of the favoriteQuoteIndices list to determine the number of items in the list
          itemCount: widget.favoriteQuoteIndices.length,
          itemBuilder: (BuildContext context, int index) {
            final favoriteQuoteIndex = widget.favoriteQuoteIndices[index];
            final favoriteQuote = widget.quotes[favoriteQuoteIndex]['quote'];
            final author = widget.quotes[favoriteQuoteIndex]['author'];
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    /// favorite quote
                    title: Text(
                      favoriteQuote,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),

                    /// author
                    subtitle: Text(
                      '$author',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    /// Del and Share buttons
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Share button
                        GestureDetector(
                          onTap: () {
                            _shareQuote(index);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),

                        /// Del button
                        GestureDetector(
                          onTap: () {
                            _removeQuote(favoriteQuoteIndex);
                            setState(
                                () {}); // Trigger a rebuild of the FavoritesScreen
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
