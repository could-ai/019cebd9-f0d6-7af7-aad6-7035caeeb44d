import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kruti Dev Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ConverterScreen(),
      },
    );
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _unicodeController = TextEditingController();
  final TextEditingController _krutiController = TextEditingController();

  void _convertToKruti() {
    setState(() {
      _krutiController.text =
          KrutiDevConverter.unicodeToKrutiDev(_unicodeController.text);
    });
  }

  void _convertToUnicode() {
    setState(() {
      _unicodeController.text =
          KrutiDevConverter.krutiDevToUnicode(_krutiController.text);
    });
  }

  void _copyToClipboard(String text) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearAll() {
    setState(() {
      _unicodeController.clear();
      _krutiController.clear();
    });
  }

  @override
  void dispose() {
    _unicodeController.dispose();
    _krutiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hindi Font Converter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear All',
            onPressed: _clearAll,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Unicode Input Section
            Expanded(
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Unicode Hindi (Standard)',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: () =>
                                _copyToClipboard(_unicodeController.text),
                            tooltip: 'Copy Unicode',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: TextField(
                          controller: _unicodeController,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            hintText: 'Type or paste standard Hindi here (e.g., नमस्ते)...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Conversion Buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _convertToKruti,
                    icon: const Icon(Icons.arrow_downward),
                    label: const Text('To Kruti Dev'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _convertToUnicode,
                    icon: const Icon(Icons.arrow_upward),
                    label: const Text('To Unicode'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Kruti Dev Input Section
            Expanded(
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Kruti Dev 010',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: () =>
                                _copyToClipboard(_krutiController.text),
                            tooltip: 'Copy Kruti Dev',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: TextField(
                          controller: _krutiController,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            hintText: 'Type or paste Kruti Dev text here (e.g., ueLrs)...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Utility class to handle conversion between Unicode Hindi and Kruti Dev 010.
class KrutiDevConverter {
  // Mapping from Unicode to Kruti Dev
  static final Map<String, String> _unicodeToKrutiMap = {
    "त्र": "«", "श्र": "J", "क्ष": "={", "ज्ञ": "K",
    "र्": "Z", // Ref (half ra)
    "ऑ": "v‚", "ॉ": "‚",
    "आ": "vk", "इ": "b", "ई": "bZ", "उ": "m", "ऊ": "Å", "ए": "ए", "ऐ": "ऐ", "ओ": "vks", "औ": "vkS", "अ": "v",
    "क": "d", "ख": "[k", "ग": "x", "घ": "?k", "ङ": "³",
    "च": "p", "छ": "N", "ज": "t", "झ": ">", "ञ": "¥",
    "ट": "V", "ठ": "B", "ड": "M", "ढ": "<", "ण": ".k",
    "त": "r", "थ": "Fk", "द": "n", "ध": "èk", "न": "u",
    "प": "i", "फ": "Q", "ब": "c", "भ": "Hk", "म": "e",
    "य": ";", "र": "j", "ल": "y", "व": "o", "श": "”k", "ष": "’k", "स": "l", "ह": "g",
    "ो": "ks", "ौ": "kS", "ं": "a", "ँ": "¡", "ः": "%",
    "ा": "k", "ी": "h", "ु": "q", "ू": "w", "ृ": "`", "े": "s", "ै": "S", "्": "~",
    "०": "å", "१": "ƒ", "२": "„", "३": "…", "४": "†", "५": "‡", "६": "ˆ", "७": "‰", "८": "Š", "९": "‹",
    "।": "A", ",": "]",
  };

  // Mapping from Kruti Dev to Unicode
  static final Map<String, String> _krutiToUnicodeMap = {
    "«": "त्र", "J": "श्र", "={": "क्ष", "K": "ज्ञ",
    "Z": "र्",
    "v‚": "ऑ", "‚": "ॉ",
    "vk": "आ", "bZ": "ई", "b": "इ", "m": "उ", "Å": "ऊ", "vks": "ओ", "vkS": "औ", "v": "अ",
    "[k": "ख", "d": "क", "x": "ग", "?k": "घ", "³": "ङ",
    "p": "च", "N": "छ", "t": "ज", ">": "झ", "¥": "ञ",
    "V": "ट", "B": "ठ", "M": "ड", "<": "ढ", ".k": "ण",
    "r": "त", "Fk": "थ", "n": "द", "èk": "ध", "u": "न",
    "i": "प", "Q": "फ", "c": "ब", "Hk": "भ", "e": "म",
    ";": "य", "j": "र", "y": "ल", "o": "व", "”k": "श", "’k": "ष", "l": "स", "g": "ह",
    "ks": "ो", "kS": "ौ", "a": "ं", "¡": "ँ", "%": "ः",
    "k": "ा", "h": "ी", "q": "ु", "w": "ू", "`": "ृ", "s": "े", "S": "ै", "~": "्",
    "å": "०", "ƒ": "१", "„": "२", "…": "३", "†": "४", "‡": "५", "ˆ": "६", "‰": "७", "Š": "८", "‹": "९",
    "A": "।", "]": ",",
  };

  /// Converts standard Unicode Hindi text to Kruti Dev 010 encoding.
  static String unicodeToKrutiDev(String unicodeText) {
    if (unicodeText.isEmpty) return "";
    String text = unicodeText;

    // 1. Shift chhoti ee (ि) to the left of the consonant
    // In Unicode, 'ि' comes after the consonant. In Kruti Dev, it comes before.
    text = text.replaceAllMapped(RegExp(r'([क-ह])ि'), (match) => 'f${match.group(1)}');
    text = text.replaceAll('ि', 'f'); // Catch any remaining

    // 2. Replace using map (longest keys first to prevent partial replacements)
    List<String> sortedKeys = _unicodeToKrutiMap.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
      
    for (String key in sortedKeys) {
      text = text.replaceAll(key, _unicodeToKrutiMap[key]!);
    }

    return text;
  }

  /// Converts Kruti Dev 010 encoded text back to standard Unicode Hindi.
  static String krutiDevToUnicode(String krutiText) {
    if (krutiText.isEmpty) return "";
    String text = krutiText;

    // 1. Replace using map (longest keys first)
    List<String> sortedKeys = _krutiToUnicodeMap.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
      
    for (String key in sortedKeys) {
      text = text.replaceAll(key, _krutiToUnicodeMap[key]!);
    }

    // 2. Shift chhoti ee (f) to the right of the consonant as 'ि'
    text = text.replaceAllMapped(RegExp(r'f([क-ह])'), (match) => '${match.group(1)}ि');
    text = text.replaceAll('f', 'ि'); // Catch any remaining

    return text;
  }
}
