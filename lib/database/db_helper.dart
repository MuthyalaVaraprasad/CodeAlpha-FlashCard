import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/flashcard_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'flashcards.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE flashcards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        category TEXT NOT NULL,
        is_studied INTEGER NOT NULL DEFAULT 0
      )
    ''');

    final List<String> categories = [
      "General Knowledge",
      "History",
      "Geography",
      "Computer Science",
      "Science",
      "Mathematics",
      "Literature",
      "Art & Culture",
      "Sports",
      "Polity & Constitution"
    ];

    final List<Map<String, String>> states = [
      { "name": "Andhra Pradesh", "capital": "Amaravati", "language": "Telugu", "bird": "Rose-ringed parakeet", "flower": "Jasmine", "animal": "Blackbuck", "tree": "Neem" },
      { "name": "Arunachal Pradesh", "capital": "Itanagar", "language": "English", "bird": "Hornbill", "flower": "Foxtail orchid", "animal": "Mithun", "tree": "Hollong" },
      { "name": "Assam", "capital": "Dispur", "language": "Assamese", "bird": "White-winged wood duck", "flower": "Foxtail orchid", "animal": "One-horned rhinoceros", "tree": "Hollong" },
      { "name": "Bihar", "capital": "Patna", "language": "Hindi", "bird": "House sparrow", "flower": "Kachnar", "animal": "Gaur", "tree": "Sacred fig" },
      { "name": "Chhattisgarh", "capital": "Raipur", "language": "Hindi", "bird": "Hill myna", "flower": "French marigold", "animal": "Wild water buffalo", "tree": "Sal" },
      { "name": "Goa", "capital": "Panaji", "language": "Konkani", "bird": "Flame-throated bulbul", "flower": "Jasmine", "animal": "Gaur", "tree": "Matti" },
      { "name": "Gujarat", "capital": "Gandhinagar", "language": "Gujarati", "bird": "Greater flamingo", "flower": "Marigold", "animal": "Asiatic lion", "tree": "Banyan" },
      { "name": "Haryana", "capital": "Chandigarh", "language": "Haryanvi", "bird": "Black francolin", "flower": "Lotus", "animal": "Blackbuck", "tree": "Sacred fig" },
      { "name": "Himachal Pradesh", "capital": "Shimla", "language": "Hindi", "bird": "Western tragopan", "flower": "Pink rhododendron", "animal": "Snow leopard", "tree": "Deodar cedar" },
      { "name": "Jharkhand", "capital": "Ranchi", "language": "Hindi", "bird": "Koel", "flower": "Palash", "animal": "Asian elephant", "tree": "Sal" },
      { "name": "Karnataka", "capital": "Bengaluru", "language": "Kannada", "bird": "Indian roller", "flower": "Lotus", "animal": "Asian elephant", "tree": "Sandalwood" },
      { "name": "Kerala", "capital": "Thiruvananthapuram", "language": "Malayalam", "bird": "Great hornbill", "flower": "Golden shower", "animal": "Asian elephant", "tree": "Coconut" },
      { "name": "Madhya Pradesh", "capital": "Bhopal", "language": "Hindi", "bird": "Indian paradise flycatcher", "flower": "Parrot tree", "animal": "Barasingha", "tree": "Banyan" },
      { "name": "Maharashtra", "capital": "Mumbai", "language": "Marathi", "bird": "Yellow-footed green pigeon", "flower": "Jarul", "animal": "Indian giant squirrel", "tree": "Mango" },
      { "name": "Manipur", "capital": "Imphal", "language": "Meitei", "bird": "Mrs. Hume's pheasant", "flower": "Shirui lily", "animal": "Sangai", "tree": "Uningthou" },
      { "name": "Meghalaya", "capital": "Shillong", "language": "Khasi", "bird": "Hill myna", "flower": "Lady's slipper orchid", "animal": "Clouded leopard", "tree": "White teak" },
      { "name": "Mizoram", "capital": "Aizawl", "language": "Mizo", "bird": "Mrs. Hume's pheasant", "flower": "Red vanda", "animal": "Serow", "tree": "Ironwood" },
      { "name": "Nagaland", "capital": "Kohima", "language": "English", "bird": "Blyth's tragopan", "flower": "Rhododendron", "animal": "Mithun", "tree": "Alder" },
      { "name": "Odisha", "capital": "Bhubaneswar", "language": "Odia", "bird": "Indian roller", "flower": "Ashoka", "animal": "Sambar deer", "tree": "Sacred fig" },
      { "name": "Punjab", "capital": "Chandigarh", "language": "Punjabi", "bird": "Northern goshawk", "flower": "Gladiolus", "animal": "Blackbuck", "tree": "Sheesham" },
      { "name": "Rajasthan", "capital": "Jaipur", "language": "Rajasthani", "bird": "Great Indian bustard", "flower": "Rohida", "animal": "Chinkara", "tree": "Khejri" },
      { "name": "Sikkim", "capital": "Gangtok", "language": "Nepali", "bird": "Blood pheasant", "flower": "Noble orchid", "animal": "Red panda", "tree": "Rhododendron" },
      { "name": "Tamil Nadu", "capital": "Chennai", "language": "Tamil", "bird": "Emerald dove", "flower": "Gloriosa lily", "animal": "Nilgiri tahr", "tree": "Palmyra palm" },
      { "name": "Telangana", "capital": "Hyderabad", "language": "Telugu", "bird": "Indian roller", "flower": "Tangedu", "animal": "Spotted deer", "tree": "Jammi" },
      { "name": "Tripura", "capital": "Agartala", "language": "Bengali", "bird": "Green imperial pigeon", "flower": "Nageswar", "animal": "Phayre's leaf monkey", "tree": "Agar" },
      { "name": "Uttar Pradesh", "capital": "Lucknow", "language": "Hindi", "bird": "Sarus crane", "flower": "Palash", "animal": "Barasingha", "tree": "Ashoka" },
      { "name": "Uttarakhand", "capital": "Dehradun", "language": "Hindi", "bird": "Himalayan monal", "flower": "Brahma Kamal", "animal": "Alpine musk deer", "tree": "Burans" },
      { "name": "West Bengal", "capital": "Kolkata", "language": "Bengali", "bird": "White-throated kingfisher", "flower": "Night-flowering jasmine", "animal": "Fishing cat", "tree": "Chatim" }
    ];

    final List<String> indianCities = ["Delhi", "Mumbai", "Kolkata", "Chennai", "Bengaluru", "Hyderabad", "Ahmedabad", "Pune", "Jaipur", "Lucknow", "Patna", "Indore", "Thane", "Bhopal", "Visakhapatnam", "Vadodara", "Ghaziabad", "Ludhiana", "Agra", "Nashik", "Ranchi", "Faridabad", "Meerut", "Rajkot", "Kalyan-Dombivli", "Vasai-Virar", "Varanasi", "Srinagar", "Aurangabad", "Dhanbad", "Amritsar", "Navi Mumbai", "Allahabad", "Howrah", "Gwalior", "Jabalpur", "Coimbatore", "Vijayawada", "Madurai", "Raipur", "Kota", "Chandigarh", "Guwahati", "Solapur", "Hubli-Dharwad", "Mysore", "Tiruchirappalli", "Bareilly", "Aligarh", "Tiruppur"];

    final List<Map<String, dynamic>> freedomFighters = [
      { "name": "Mahatma Gandhi", "title": "Father of the Nation", "keyEvent": "Dandi March", "year": 1930 },
      { "name": "Subhas Chandra Bose", "title": "Netaji", "keyEvent": "establishment of Indian National Army", "year": 1942 },
      { "name": "Bhagat Singh", "title": "Shaheed-e-Azam", "keyEvent": "assembly bombing case", "year": 1929 },
      { "name": "Sardar Vallabhbhai Patel", "title": "Iron Man of India", "keyEvent": "integration of princely states", "year": 1947 },
      { "name": "Bal Gangadhar Tilak", "title": "Lokmanya", "keyEvent": "founding the Home Rule League", "year": 1916 },
      { "name": "Lala Lajpat Rai", "title": "Punjab Kesari", "keyEvent": "protests against Simon Commission", "year": 1928 },
      { "name": "Jawaharlal Nehru", "title": "Chacha Nehru", "keyEvent": "drafting the Resolution for Purna Swaraj", "year": 1929 },
      { "name": "Chandra Shekhar Azad", "title": "Azad", keyEvent: "Kakori Conspiracy", "year": 1925 },
      { "name": "Rani Lakshmibai", "title": "Queen of Jhansi", "keyEvent": "Revolt of 1857", "year": 1857 },
      { "name": "Mangal Pandey", "title": "Sepoy Mutiny pioneer", "keyEvent": "barrackpore uprising", "year": 1857 },
      { "name": "Gopal Krishna Gokhale", "title": "Political guru of Gandhi", "keyEvent": "founding Servants of India Society", "year": 1905 },
      { "name": "Bipin Chandra Pal", "title": "Father of Revolutionary Thoughts in India", "keyEvent": "Swadeshi movement promotion", "year": 1905 },
      { "name": "Dr. B.R. Ambedkar", "title": "Father of the Indian Constitution", "keyEvent": "Chadar Lake Satyagraha", "year": 1927 },
      { "name": "Dr. Rajendra Prasad", "title": "Deshratna", "keyEvent": "Presidency of Constituent Assembly", "year": 1946 },
      { "name": "Abul Kalam Azad", "title": "First Education Minister of India", "keyEvent": "Khilafat movement participation", "year": 1920 }
    ];

    final List<Map<String, String>> mathFormulas = [
      { "name": "Area of a Circle", "formula": "πr²" },
      { "name": "Circumference of a Circle", "formula": "2πr" },
      { "name": "Area of a Rectangle", "formula": "length × width" },
      { "name": "Pythagorean Theorem", "formula": "a² + b² = c²" },
      { "name": "Volume of a Sphere", "formula": "(4/3)πr³" },
      { "name": "Quadratic Formula", "formula": "x = [-b ± &(b² - 4ac)] / 2a" },
      { "name": "Area of a Triangle", "formula": "0.5 × base × height" },
      { "name": "Euler's Identity", "formula": "e^(iπ) + 1 = 0" },
      { "name": "Derivative of x^n", "formula": "n*x^(n-1)" },
      { "name": "Integral of 1/x", "formula": "ln|x| + C" }
    ];

    final List<Map<String, String>> indianScientists = [
      { "name": "C.V. Raman", "discovery": "Raman Effect (scattering of light)", "year": "1930" },
      { "name": "Jagadish Chandra Bose", "discovery": "Crescograph and plant response", "year": "1901" },
      { "name": "Satyendra Nath Bose", "discovery": "Bose-Einstein statistics", "year": "1924" },
      { "name": "Homi J. Bhabha", "discovery": "Indian nuclear program architecture", "year": "1948" },
      { "name": "Vikram Sarabhai", "discovery": "Indian Space Research Organisation (ISRO)", "year": "1969" },
      { "name": "APJ Abdul Kalam", "discovery": "Satellite Launch Vehicle SLV-3 and missile systems", "year": "1980" },
      { "name": "Hargobind Khorana", "discovery": "Interpretation of genetic code", "year": "1968" },
      { "name": "Subrahmanyan Chandrasekhar", "discovery": "Chandrasekhar Limit of white dwarf stars", "year": "1930" },
      { "name": "Srinivasa Ramanujan", "discovery": "Ramanujan Prime and Mock Theta Functions", "year": "1913" },
      { "name": "Birbal Sahni", "discovery": "Study of Indian fossil plants (Paleobotany)", "year": "1920" }
    ];

    final List<Map<String, dynamic>> isroMissions = [
      { "name": "Chandrayaan-1", "year": 2008, "goal": "detecting water molecules on the Moon" },
      { "name": "Mangalyaan (MOM)", "year": 2013, "goal": "orbiting Mars on the first attempt" },
      { "name": "Chandrayaan-2", "year": 2019, "goal": "exploring the lunar south pole terrain" },
      { "name": "Chandrayaan-3", "year": 2023, "goal": "soft landing on the lunar south pole" },
      { "name": "Aditya-L1", "year": 2023, "goal": "studying the solar atmosphere from Lagrange point L1" },
      { "name": "Gaganyaan", "year": 2025, "goal": "demonstrating human spaceflight capability" },
      { "name": "GSAT-1", "year": 2001, "goal": "improving telecommunication services in India" },
      { "name": "Astrosat", "year": 2015, "goal": "multi-wavelength space observatory observations" },
      { "name": "RISAT-1", "year": 2012, "goal": "all-weather radar imaging operations" },
      { "name": "Cartosat-1", "year": 2005, "goal": "high-resolution land mapping in India" }
    ];

    final List<Map<String, String>> dynamicMonuments = [
      { "name": "Taj Mahal", "city": "Agra", "year": "1648", "builder": "Shah Jahan" },
      { "name": "Qutub Minar", "city": "Delhi", "year": "1220", "builder": "Qutb-ud-din Aibak" },
      { "name": "Red Fort", "city": "Delhi", "year": "1648", "builder": "Shah Jahan" },
      { "name": "Gateway of India", "city": "Mumbai", "year": "1924", "builder": "British Raj" },
      { "name": "Hawa Mahal", "city": "Jaipur", "year": "1799", "builder": "Maharaja Sawai Pratap Singh" },
      { "name": "Charminar", "city": "Hyderabad", "year": "1591", "builder": "Muhammad Quli Qutb Shah" },
      { "name": "Victoria Memorial", "city": "Kolkata", "year": "1921", "builder": "William Emerson" },
      { "name": "Konark Sun Temple", "city": "Puri", "year": "1250", "builder": "King Narasimhadeva I" },
      { "name": "Sanchi Stupa", "city": "Sanchi", "year": "3rd Century BCE", "builder": "Emperor Ashoka" },
      { "name": "Gol Gumbaz", "city": "Vijayapura", "year": "1656", "builder": "Mohammed Adil Shah" },
      { "name": "Brihadisvara Temple", "city": "Thanjavur", "year": "1010", "builder": "Raja Raja Chola I" },
      { "name": "India Gate", "city": "New Delhi", "year": "1931", "builder": "Edwin Lutyens" },
      { "name": "Fatehpur Sikri", "city": "Agra", "year": "1571", "builder": "Emperor Akbar" },
      { "name": "Mysore Palace", "city": "Mysore", "year": "1912", "builder": "Krishnaraja Wodeyar IV" },
      { "name": "Ajanta Caves", "city": "Aurangabad", "year": "2nd Century BCE", "builder": "Satavahana Dynasty" }
    ];

    final Batch batch = db.batch();

    for (var cat in categories) {
      const int targetIndia = 432; // ~80%
      const int targetWorld = 107; // ~20%

      // India Cards Generation
      for (int i = 1; i <= targetIndia; i++) {
        String q = "";
        String a = "";

        if (cat == "General Knowledge") {
          var state = states[i % states.length];
          int type = i % 6;
          if (type == 0) {
            q = "What is the capital of the Indian state/UT of ${state['name']}?";
            a = state['capital']!;
          } else if (type == 1) {
            q = "What is the official state animal of ${state['name']} in India?";
            a = state['animal']!;
          } else if (type == 2) {
            q = "What is the official state bird of ${state['name']} in India?";
            a = state['bird']!;
          } else if (type == 3) {
            q = "What is the official state flower of ${state['name']} in India?";
            a = state['flower']!;
          } else if (type == 4) {
            q = "What is the official state tree of ${state['name']} in India?";
            a = state['tree']!;
          } else {
            q = "What is the primary official language spoken in ${state['name']}, India?";
            a = state['language']!;
          }
        } else if (cat == "History") {
          var ff = freedomFighters[i % freedomFighters.length];
          var mon = dynamicMonuments[i % dynamicMonuments.length];
          int type = i % 4;
          if (type == 0) {
            q = "Which Indian freedom fighter is widely known as '${ff['title']}'?";
            a = ff['name']!;
          } else if (type == 1) {
            q = "In which year did the Indian historical event of the ${ff['keyEvent']} take place?";
            a = ff['year']!.toString();
          } else if (type == 2) {
            q = "Who built the famous historical monument ${mon['name']} in ${mon['city']}, India?";
            a = mon['builder']!;
          } else {
            q = "In which historical location/city in India is the monument ${mon['name']} situated?";
            a = mon['city']!;
          }
        } else if (cat == "Geography") {
          var state = states[i % states.length];
          var city = indianCities[i % indianCities.length];
          var crops = ["Wheat", "Rice", "Cotton", "Tea", "Coffee", "Jute", "Sugarcane", "Rubber", "Spices", "Tobacco"];
          var crop = crops[i % crops.length];
          int type = i % 3;
          if (type == 0) {
            q = "Which Indian state is majorly noted for the highest agricultural production of $crop?";
            a = state['name']!;
          } else if (type == 1) {
            q = "Identify the Indian state where the capital is ${state['capital']}:";
            a = state['name']!;
          } else {
            q = "Which major Indian city or urban area is historically known as city ID: geo-$i?";
            a = city;
          }
        } else if (cat == "Computer Science") {
          var companyInfo = [
            { "name": "Infosys", "founder": "N. R. Narayana Murthy" },
            { "name": "Wipro", "founder": "M.H. Hasham Premji" },
            { "name": "TCS", "founder": "Tata Sons" },
            { "name": "HCL", "founder": "Shiv Nadar" }
          ];
          var co = companyInfo[i % companyInfo.length];
          var sci = indianScientists[i % indianScientists.length];
          int type = i % 4;
          if (type == 0) {
            q = "Which Indian city is globally recognized as the 'Silicon Valley of India'?";
            a = "Bengaluru";
          } else if (type == 1) {
            q = "Who is credited as the primary founder of the Indian IT giant ${co['name']}?";
            a = co['founder']!;
          } else if (type == 2) {
            q = "What is the name of India's first indigenous supercomputer, launched in 1991?";
            a = "PARAM 8000";
          } else {
            q = "Which Indian technology institute did mathematician/scientist ${sci['name']} interact with?";
            a = "IIT Kharagpur";
          }
        } else if (cat == "Science") {
          var sci = indianScientists[i % indianScientists.length];
          var mis = isroMissions[i % isroMissions.length];
          int type = i % 3;
          if (type == 0) {
            q = "Which famous Indian scientist is credited with the discovery of the ${sci['discovery']}?";
            a = sci['name']!;
          } else if (type == 1) {
            q = "In which year did the Indian Space Research Organisation (ISRO) launch the ${mis['name']} mission?";
            a = mis['year']!.toString();
          } else {
            q = "What was the primary scientific objective of the ISRO satellite mission ${mis['name']}?";
            a = mis['goal']!;
          }
        } else if (cat == "Mathematics") {
          var mathGuys = [
            { "name": "Aryabhata", "book": "Aryabhatiya" },
            { "name": "Brahmagupta", "book": "Brahmasphutasiddhanta" },
            { "name": "Srinivasa Ramanujan", "book": "Notebooks on Mock Theta Functions" },
            { "name": "Bhaskara II", "book": "Lilavati" }
          ];
          var guy = mathGuys[i % mathGuys.length];
          int type = i % 3;
          if (type == 0) {
            q = "Which ancient Indian mathematician is famous for writing the treatise '${guy['book']}'?";
            a = guy['name']!;
          } else if (type == 1) {
            q = "Which mathematical concept is Aryabhata famously credited with introducing to world mathematics?";
            a = "Zero";
          } else {
            int distance = 100 + i * 5;
            int hours = 2 + (i % 3);
            q = "If an Indian Railways express train travels from New Delhi to a station $distance km away in $hours hours, what is its average speed in km/h?";
            a = "${(distance / hours).toStringAsFixed(1)} km/h";
          }
        } else if (cat == "Literature") {
          var books = [
            { "title": "Gitanjali", "author": "Rabindranath Tagore", "lang": "Bengali" },
            { "title": "Panchatantra", "author": "Vishnu Sharma", "lang": "Sanskrit" },
            { "title": "The Guide", "author": "R.K. Narayan", "lang": "English" },
            { "title": "Godan", "author": "Munshi Premchand", "lang": "Hindi" },
            { "title": "Discovery of India", "author": "Jawaharlal Nehru", "lang": "English" }
          ];
          var bk = books[i % books.length];
          int type = i % 3;
          if (type == 0) {
            q = "Who is the celebrated Indian author of the book/literary work '${bk['title']}'?";
            a = bk['author']!;
          } else if (type == 1) {
            q = "In which language was the classic Indian literary work '${bk['title']}' originally composed?";
            a = bk['lang']!;
          } else {
            q = "Which Indian poet/author won the Nobel Prize in Literature in 1913 for 'Gitanjali'?";
            a = "Rabindranath Tagore";
          }
        } else if (cat == "Art & Culture") {
          var dances = [
            { "name": "Bharatanatyam", "state": "Tamil Nadu" },
            { "name": "Kathakali", "state": "Kerala" },
            { "name": "Kathak", "state": "Uttar Pradesh" },
            { "name": "Odissi", "state": "Odisha" },
            { "name": "Kuchipudi", "state": "Andhra Pradesh" }
          ];
          var dance = dances[i % dances.length];
          var instrumentPlayers = [
            { "player": "Pandit Ravi Shankar", "instrument": "Sitar" },
            { "player": "Ustad Bismillah Khan", "instrument": "Shehnai" },
            { "player": "Ustad Zakir Hussain", "instrument": "Tabla" }
          ];
          var ip = instrumentPlayers[i % instrumentPlayers.length];
          int type = i % 3;
          if (type == 0) {
            q = "Which Indian state is historically and culturally associated with the classical dance '${dance['name']}'?";
            a = dance['state']!;
          } else if (type == 1) {
            q = "Which musical instrument is the legendary Indian musician ${ip['player']} famous for playing?";
            a = ip['instrument']!;
          } else {
            q = "Which state in India is famous for the traditional painting style called Madhubani art?";
            a = "Bihar";
          }
        } else if (cat == "Sports") {
          var athletes = [
            { "name": "Neeraj Chopra", "sport": "Javelin Throw" },
            { "name": "Sachin Tendulkar", "sport": "Cricket" },
            { "name": "P.V. Sindhu", "sport": "Badminton" },
            { "name": "Major Dhyan Chand", "sport": "Field Hockey" }
          ];
          var ath = athletes[i % athletes.length];
          int type = i % 3;
          if (type == 0) {
            q = "With which sport is the famous Indian athlete ${ath['name']} primarily associated?";
            a = ath['sport']!;
          } else if (type == 1) {
            q = "Identify the country represented by gold medalist athlete ${ath['name']}:";
            a = "India";
          } else {
            q = "How many times has India won the ICC Men's Cricket World Cup in the 50-over format?";
            a = "2 times (1983 and 2011)";
          }
        } else if (cat == "Polity & Constitution") {
          var constitutionElements = [
            { "term": "Article 14", "description": "Right to Equality" },
            { "term": "Article 21", "description": "Right to Life and Personal Liberty" },
            { "term": "Part III", "description": "Fundamental Rights" }
          ];
          var elem = constitutionElements[i % constitutionElements.length];
          int type = i % 3;
          if (type == 0) {
            q = "Which part or article of the Indian Constitution covers the '${elem['description']}'?";
            a = elem['term']!;
          } else if (type == 1) {
            q = "Who is widely remembered as the chief architect and 'Father of the Indian Constitution'?";
            a = "Dr. B.R. Ambedkar";
          } else {
            q = "What is the minimum age requirement to qualify as a candidate for the Indian Lok Sabha elections?";
            a = "25 years";
          }
        }

        batch.insert('flashcards', {
          'question': q,
          'answer': a,
          'category': cat,
          'is_studied': 0
        });
      }

      // World Cards Generation
      for (int j = 1; j <= targetWorld; j++) {
        String q = "";
        String a = "";

        if (cat == "General Knowledge") {
          var worldCapitals = [
            { "country": "Japan", "capital": "Tokyo" },
            { "country": "Australia", "capital": "Canberra" }
          ];
          var cap = worldCapitals[j % worldCapitals.length];
          q = "What is the official capital city of ${cap['country']}?";
          a = cap['capital']!;
        } else if (cat == "History") {
          q = "In which year did the global historical event of the start of World War I occur?";
          a = "1914";
        } else if (cat == "Geography") {
          q = "Which global geographical feature is identified as the tallest mountain peak in the world?";
          a = "Mount Everest";
        } else if (cat == "Computer Science") {
          q = "In computer science, what does the technical acronym 'CPU' stand for?";
          a = "Central Processing Unit";
        } else if (cat == "Science") {
          q = "On the scientific periodic table of chemical elements, what element does symbol 'Au' represent?";
          a = "Gold";
        } else if (cat == "Mathematics") {
          var formula = mathFormulas[j % mathFormulas.length];
          q = "What is the standard mathematical formula or representation for '${formula['name']}'?";
          a = formula['formula']!;
        } else if (cat == "Literature") {
          q = "Who is the world-renowned author of the classic novel/literary work 'Hamlet'?";
          a = "William Shakespeare";
        } else if (cat == "Art & Culture") {
          q = "Who is the famous artist/creator of the global masterpiece 'Mona Lisa painting'?";
          a = "Leonardo da Vinci";
        } else if (cat == "Sports") {
          q = "In global sports history, what is a key frequency associated with the FIFA World Cup?";
          a = "Every 4 years";
        } else if (cat == "Polity & Constitution") {
          q = "In global political systems, identify the headquarters city of the United Nations:";
          a = "New York City";
        }

        batch.insert('flashcards', {
          'question': q,
          'answer': a,
          'category': cat,
          'is_studied': 0
        });
      }
    }

    await batch.commit(noResult: true);
  }

  // --- CRUD API ---

  // Insert Flashcard
  Future<int> insertFlashcard(Flashcard card) async {
    final db = await database;
    return await db.insert('flashcards', card.toMap());
  }

  // Fetch All Flashcards
  Future<List<Flashcard>> fetchAllFlashcards() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('flashcards');
    return List.generate(maps.length, (i) => Flashcard.fromMap(maps[i]));
  }

  // Update Flashcard
  Future<int> updateFlashcard(Flashcard card) async {
    final db = await database;
    return await db.update(
      'flashcards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  // Delete Flashcard
  Future<int> deleteFlashcard(int id) async {
    final db = await database;
    return await db.delete(
      'flashcards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Clear Database
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('flashcards');
  }
}
