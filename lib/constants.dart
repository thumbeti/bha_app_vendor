List<String> rentalSubModes = ['Monthly', 'Daily'];

List<String> weeklyOffDay = ['SAT', 'SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'NO-OFF'];
List<String> shopTypes = ['Meat Seller', 'Groceries', 'Service Provider'];
List<String> loadProductTypes = ['Mutton + Chicken + Fish', 'Mutton + Chicken',
                                  'Mutton', 'Chicken', 'Fish',
                                  'Groceries',
                                  'Service Provider'
                                ];
List<String> shopStates = ['NEW', 'OPEN', 'CLOSED'];

const String CALL_VISIT = 'Call/Visit to check';

List<String> units = ['Kg', 'Grm', 'Liter', 'Ml', 'Nos', 'Feet', 'Yard', 'Set', CALL_VISIT ];
List<String> TAX_STATUS = ['Non Taxable', 'Taxable'];

const double oneTimeRegistrationFee = 83.90;
//const double oneTimeRegistrationFee = 5;
const int cgst_B = 9;
const int sgst_B = 9;
const int igst_B = 0;
const int cgst_NB = 0;
const int sgst_NB = 0;
const int igst_NB = 18;

const String OXY_TAX_AREA = "Karnataka";

const String DEFAULT_EMAIL = 'info@jiosmart.in';

String termsAndConditions = 'I hereby confirm the following: \n\n'
    '1. I am the sole owner and I will take the responsibility of any issues whatsoever that may arise\n'
    'with regard to the products/services that we supplied/provided to customers through BhaApp\n'
    'app and hereby release the Oxysmart Private Limited from any liability as a result of the\n'
    'products/services consumption OR related to delivery of products / services.\n'
    '2. I will ensure the product/services supplied/provided by me are of the same specifications\n'
    'as mentioned in the portal and I am expecting the payment only after the customer given \n'
    'the confirmation on delivery and product/services satisfied to customer.'
    '3. Rs 99 (including GST) is charged against the “adding my shop details along with our products /\n'
    'services to BhaApp” portal. This fee is one time AND non-refundable.\n'
    '4. There may be delay in launching the BhaApp app. Sometimes App may not function due to\n'
    'technical issues and App may have to be shut down till the technical problems are resolved.\n'
    '5. Subject to "Karnataka" jurisdiction only.';

Map<String, double> TAXPERCENTS = {'GST-5%': 5.0, 'GST-12%': 12.0, 'GST-18%': 18.0, 'GST-28%': 28.0};

const String CHICKEN_PIC_DIR = 'Chicken';
const String MUTTTON_PIC_DIR = 'Mutton';
const String FISH_PIC_DIR = 'Fish';
const String SERVICES_PIC_DIR = 'Services';

List<Map<String, dynamic>> getCommonProducts(String loadProductType) {
  var products = <Map<String, dynamic>>[];

  if(loadProductType.contains('Chicken')) {
    //Chicken
    products.add(
        { 'name': 'Whole chicken - without skin - curry cut - small pieces',
          'desc': 'Whole chicken - without skin - curry cut - small pieces',
          'KGPrice': '300',
          'PicDir': CHICKEN_PIC_DIR,
          'subCategory': 'Chicken',
          'PicName': 'Whole chicken  - without skin - curry cut - small pieces.jpeg',
        });

    products.add(
        { 'name': 'Whole chicken - without skin - curry cut - medium pieces',
          'desc': 'Whole chicken - without skin - curry cut - medium pieces',
          'KGPrice': '300',
          'PicDir': CHICKEN_PIC_DIR,
          'subCategory': 'Chicken',
          'PicName': 'Whole chicken  - without skin - curry cut - medium pieces.jpeg',
        });

    products.add(
        { 'name': 'Whole chicken - without skin - curry cut - large pieces',
          'desc': 'Whole chicken - without skin - curry cut - large pieces',
          'KGPrice': '300',
          'PicDir': CHICKEN_PIC_DIR,
          'subCategory': 'Chicken',
          'PicName': 'Whole chicken  - without skin - curry cut - large pieces.jpeg',
        });

    products.add({ 'name': 'Boneless – medium pieces',
      'desc': 'Boneless – medium pieces',
      'KGPrice': '400',
      'PicDir': CHICKEN_PIC_DIR,
      'subCategory': 'Chicken',
      'PicName': 'Boneless – medium pieces.jpeg',
    });

    products.add({ 'name': 'Chicken - Liver',
      'desc': 'Chicken - Liver',
      'KGPrice': '150',
      'PicDir': CHICKEN_PIC_DIR,
      'subCategory': 'Chicken',
      'PicName': 'Liver.jpeg',
    });

    products.add({ 'name': 'Chicken - Breast Pieces',
      'desc': 'Chicken - Breast Pieces',
      'KGPrice': '400',
      'PicDir': CHICKEN_PIC_DIR,
      'subCategory': 'Chicken',
      'PicName': 'Breast Pieces.jpeg',
    });

    products.add({ 'name': 'Chicken - Leg Pieces',
      'desc': 'Chicken - Leg Pieces',
      'KGPrice': '350',
      'PicDir': CHICKEN_PIC_DIR,
      'subCategory': 'Chicken',
      'PicName': 'Leg Pieces.jpeg',
    });

    products.add(
        { 'name': 'Whole chicken - with skin - curry cut - medium pieces',
          'desc': 'Whole chicken - with skin - curry cut - medium pieces',
          'KGPrice': '275',
          'PicDir': CHICKEN_PIC_DIR,
          'subCategory': 'Chicken',
          'PicName': 'Whole chicken  - with skin - curry cut - medium pieces.jpeg',
        });

    products.add(
        { 'name': 'Whole chicken - with skin - curry cut - large pieces',
          'desc': 'Whole chicken - with skin - curry cut - large pieces',
          'KGPrice': '275',
          'PicDir': CHICKEN_PIC_DIR,
          'subCategory': 'Chicken',
          'PicName': 'Whole chicken  - with skin - curry cut - large pieces.jpeg',
        });

    products.add(
        { 'name': 'Country/Nati Chicken - with skin - burnt - medium pieces',
          'desc': 'Country/Nati Chicken - with skin - burnt - medium pieces',
          'KGPrice': '350',
          'PicDir': CHICKEN_PIC_DIR,
          'subCategory': 'Chicken',
          'PicName': 'CountryNati Chicken - with skin - burnt - medium pieces.jpeg',
        });
  }

  if(loadProductType.contains('Mutton')) {
    //Motton
    products.add({ 'name': 'Lamb - Boneless - curry cut - small pieces',
      'desc': 'Lamb - Boneless - curry cut - small pieces',
      'KGPrice': '1500',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Lamb - Boneless - curry cut - small pieces.jpeg',
    });

    products.add({ 'name': 'Lamb - Boneless - curry cut - medium pieces',
      'desc': 'Lamb - Boneless - curry cut - medium pieces',
      'KGPrice': '1500',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Lamb - Boneless - curry cut - medium pieces.jpeg',
    });

    products.add(
        { 'name': 'Lamb - Boneless - curry cut - large(biryani) pieces',
          'desc': 'Lamb - Boneless - curry cut - large(biryani) pieces',
          'KGPrice': '1500',
          'PicDir': MUTTTON_PIC_DIR,
          'subCategory': 'Mutton',
          'PicName': 'Lamb - Boneless - curry cut - large(biryani) pieces.jpeg',
        });
    products.add({ 'name': 'Lamb - with bone - curry cut - small pieces',
      'desc': 'Lamb - with bone - curry cut - small pieces',
      'KGPrice': '1000',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Lamb - with bone - curry cut - small pieces.jpeg',
    });
    products.add({ 'name': 'Lamb - with bone - curry cut - medium pieces',
      'desc': 'Lamb - with bone - curry cut - medium pieces',
      'KGPrice': '1000',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Lamb - with bone - curry cut - medium pieces.jpeg',
    });
    products.add(
        { 'name': 'Lamb - with bone - curry cut - large(biryani) pieces',
          'desc': 'Lamb - with bone - curry cut - large(biryani) pieces',
          'KGPrice': '1000',
          'PicDir': MUTTTON_PIC_DIR,
          'subCategory': 'Mutton',
          'PicName': 'Lamb - with bone - curry cut - large(biryani) pieces.jpeg',
        });
    products.add({ 'name': 'Lamb - Chops & Ribs',
      'desc': 'Lamb - Chops & Ribs',
      'KGPrice': '1000',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Lamb - Chops _ Ribs.jpeg',
    });
    products.add({ 'name': 'Lamb - Chops',
      'desc': 'Lamb - Chops',
      'KGPrice': '1000',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Lamb - Chops.jpeg',
    });
    products.add({ 'name': 'Lamb - Keema',
      'desc': 'Lamb - Keema',
      'KGPrice': '1600',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Lamb - Keema.jpeg',
    });
    products.add({ 'name': 'Goat - Boneless - curry cut - small pieces',
      'desc': 'Goat - Boneless - curry cut - small pieces',
      'KGPrice': '1500',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Item 10.jpg',
    });
    products.add({ 'name': 'Goat - Boneless - curry cut - medium pieces',
      'desc': 'Goat - Boneless - curry cut - medium pieces',
      'KGPrice': '1500',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Item 11.jpg',
    });
    products.add(
        { 'name': 'Goat - Boneless - curry cut - large(biryani) pieces',
          'desc': 'Goat - Boneless - curry cut - large(biryani) pieces',
          'KGPrice': '1500',
          'PicDir': MUTTTON_PIC_DIR,
          'subCategory': 'Mutton',
          'PicName': 'Item 12.jpg',
        });
    products.add({ 'name': 'Goat - with bone - curry cut - small pieces',
      'desc': 'Goat - with bone - curry cut - small pieces',
      'KGPrice': '1000',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Goat - with bone - curry cut - small pieces.jpeg',
    });
    products.add({ 'name': 'Goat - with bone - curry cut - medium pieces',
      'desc': 'Goat - with bone - curry cut - medium pieces',
      'KGPrice': '1000',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Goat - with bone - curry cut - medium pieces.jpeg',
    });
    products.add(
        { 'name': 'Goat - with bone - curry cut - large(biryani) pieces',
          'desc': 'Goat - with bone - curry cut - large(biryani) pieces',
          'KGPrice': '1000',
          'PicDir': MUTTTON_PIC_DIR,
          'subCategory': 'Mutton',
          'PicName': 'Goat - with bone - curry cut - large(biryani) pieces.jpeg',
        });
    products.add({ 'name': 'Goat - Chops & Ribs',
      'desc': 'Goat - Chops & Ribs',
      'KGPrice': '1000',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Item 16.jpg',
    });
    products.add({ 'name': 'Goat - Chops',
      'desc': 'Goat - Chops',
      'KGPrice': '1000',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Goat - Chops.jpeg',
    });
    products.add({ 'name': 'Goat - Keema',
      'desc': 'Goat - Keema',
      'KGPrice': '1600',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Goat - Keema.jpeg',
    });
    products.add({ 'name': 'Mutton - Fat',
      'desc': 'Mutton - Fat',
      'KGPrice': '500',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Item 19.jpg',
    });
    products.add({ 'name': 'Mutton - Kidney',
      'desc': 'Mutton - Kidney',
      'KGPrice': '800',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Kidney.jpeg',
    });
    products.add({ 'name': 'Mutton - Liver',
      'desc': 'Mutton - Liver',
      'KGPrice': '800',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Liver.jpeg',
    });
    products.add({ 'name': 'Mutton - Heart',
      'desc': 'Mutton - Heart',
      'KGPrice': '800',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Heart.jpeg',
    });
    products.add({ 'name': 'Mutton - Brain',
      'desc': 'Mutton - Brain',
      'KGPrice': '1600',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Item 23.jpg',
    });
    products.add({ 'name': 'Mutton - Soup Bones',
      'desc': 'Mutton - Soup Bones',
      'KGPrice': '550',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Soup Bones.jpeg',
    });
    products.add({ 'name': 'Mutton - Head',
      'desc': 'Mutton - Head',
      'KGPrice': '1200',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Head.jpeg',
    });
    products.add({ 'name': 'Mutton - Legs',
      'desc': 'Mutton - Legs',
      'KGPrice': '1200',
      'PicDir': MUTTTON_PIC_DIR,
      'subCategory': 'Mutton',
      'PicName': 'Legs.jpeg',
    });
  }

  //FISH
  if(loadProductType.contains('Fish')) {
    products.add({ 'name': 'ROHU',
      'desc': 'Rohu',
      'KGPrice': '250',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'ROHU.jpeg',
      'fishCategory' : 'FreshWater'
    });
    products.add({ 'name': 'TALAPIA',
      'desc': 'TALAPIA',
      'KGPrice': '250',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'TILAPIA.jpeg',
      'fishCategory' : 'FreshWater'
    });
    products.add({ 'name': 'CATLA',
      'desc': 'CATLA',
      'KGPrice': '250',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'CATLA.jpeg',
      'fishCategory' : 'FreshWater'
    });
    products.add({ 'name': 'PEARL SPOT / KARIMEEN / KORAL',
      'desc': 'PEARL SPOT / KARIMEEN / KORAL',
      'KGPrice': '350',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'PEARL SPOTKARIMEENKORAL.jpeg',
      'fishCategory' : 'FreshWater'
    });
    products.add({ 'name': 'SINGHARA/SEENGHALA/AYER/AAR/LONG WHISKERE CATFISH/VELLAKORI',
      'desc': 'SINGHARA/SEENGHALA/AYER/AAR/LONG WHISKERE CATFISH/VELLAKORI',
      'KGPrice': '450',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'SINGHARASEENGHALAAYERAARLONG WHISKERE CATFISHVELLAKORI.jpeg',
      'fishCategory' : 'FreshWater'
    });
    products.add({ 'name': 'BARRAMUNDI/BHEKTHI/ASIAN SEA BASS',
      'desc': 'BARRAMUNDI/BHEKTHI/ASIAN SEA BASS',
      'KGPrice': '1200',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'BARRAMUNDIBHEKTHIASIAN SEA BASS.jpg',
      'fishCategory' : 'FreshWater'
    });
    products.add({ 'name': 'PINK PERCH/RED FISH/SANKARA',
      'desc': 'PINK PERCH/RED FISH/SANKARA',
      'KGPrice': '550',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'PINK PERCHRED FISHSANKARA.jpeg',
      'fishCategory' : 'FreshWater'
    });
    products.add({ 'name': 'BOAL FISH',
      'desc': 'BOAL FISH',
      'KGPrice': '550',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'BOAL FISH.jpeg',
      'fishCategory' : 'FreshWater'
    });
    products.add({ 'name': 'PABDA FISH',
      'desc': 'PABDA FISH',
      'KGPrice': '750',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'PABDA FISH.jpeg',
      'fishCategory' : 'FreshWater'
    });
    products.add({ 'name': 'WHITE PRAWNS/ CHEMMEEN',
      'desc': 'WHITE PRAWNS/ CHEMMEEN',
      'KGPrice': '650',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'WHITE PRAWNS CHEMMEEN.jpeg',
      'fishCategory' : 'FreshWater'
    });
    products.add({ 'name': 'TIGER PRAWNS',
      'desc': 'TIGER PRAWNS',
      'KGPrice': '1800',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'TIGER PRAWNS.jpeg',
      'fishCategory' : 'FreshWater'
    });
    products.add({ 'name': 'INDIAN SALMON/VAZHMEEN/RAAVAS/GURJALI',
      'desc': 'INDIAN SALMON/VAZHMEEN/RAAVAS/GURJALI',
      'KGPrice': '1000',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'INDIAN SALMON VAZHMEENRAAVASGURJALI.jpeg',
      'fishCategory' : 'FreshWater'
    });
    products.add({ 'name': 'HILSA/ELISH/PALAVA',
      'desc': 'HILSA/ELISH/PALAVA',
      'KGPrice': '1000',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'HILSAELISHPALUVA.jpeg',
      'fishCategory' : 'FreshWater'
    });
    products.add({ 'name': 'KAJOLI FISH',
      'desc': 'KAJOLI FISH',
      'KGPrice': '1000',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'KAJOLI FISH.jpeg',
      'fishCategory' : 'FreshWater'
    });
    products.add({ 'name': 'SNAKE HEAD FISH/ VARAAL/BRAL/KANNAN/SHOL/MURREL',
      'desc': 'SNAKE HEAD FISH/ VARAAL/BRAL/KANNAN/SHOL/MURREL',
      'KGPrice': '500',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'SNAKE HEAD FISH VARAAL BRALKANNANSHOLMURREL.jpeg',
      'fishCategory' : 'FreshWater'
    });
    products.add({ 'name': 'FRESH INDIAN BASA / PANGAS',
      'desc': 'FRESH INDIAN BASA / PANGAS',
      'KGPrice': '250',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'FRESH INDIAN BASA  PANGAS.jpeg',
      'fishCategory' : 'FreshWater'
    });

    //Sea Fish
    products.add({ 'name': 'VANJARAM',
      'desc': 'VANJARAM',
      'KGPrice': '1000',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'VANJARAM.jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'MACKEREL/BANGDA',
      'desc': 'MACKEREL/BANGDA',
      'KGPrice': '300',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'MACKERELBANGDA.jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'EMPEROR/VILAI MEEN/ERIMEENU',
      'desc': 'EMPEROR/VILAI MEEN/ERIMEENU',
      'KGPrice': '500',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'EMPERORVILAI MEENERIMEENU.jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'SARDINE/MATHI',
      'desc': 'SARDINE/MATHI',
      'KGPrice': '300',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'SARDINEMATHI.jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'TUNA/CHOORA/CHOORAI/SURAI',
      'desc': 'TUNA/CHOORA/CHOORAI/SURAI',
      'KGPrice': '500',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'TUNACHOORACHOORAISURAI.jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'BLACK POMFRET/AVOLI/VAVAL/CHANDI/MANJI',
      'desc': 'BLACK POMFRET/AVOLI/VAVAL/CHANDI/MANJI',
      'KGPrice': '1450',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'BLACK POMFRET AVOLIVAVALCHANDIMANJI).jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'WHITE POMFRET/AVOLI/PAPLET',
      'desc': 'WHITE POMFRET/AVOLI/PAPLET',
      'KGPrice': '1900',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'WHITE POMFRETAVOLIPAPLET.jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'SILVER POMFRET/ WHITE POMFRET',
      'desc': 'SILVER POMFRET/ WHITE POMFRET',
      'KGPrice': '3900',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'SILVER POMFRET WHITE POMFRET.jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'WHITE SARDINE/ SILVER FISH/VELOORI',
      'desc': 'WHITE SARDINE/ SILVER FISH/VELOORI',
      'KGPrice': '300',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'WHITE SARDINE SILVER FISHVELOORI.jpg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'ROOPCHAND',
      'desc': 'ROOPCHAND',
      'KGPrice': '270',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'ROOPCHAND.jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'SHARK',
      'desc': 'SHARK',
      'KGPrice': '1500',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'SHARK.jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'ANCHOVY/NATHOLI',
      'desc': 'ANCHOVY/NATHOLI',
      'KGPrice': '500',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'ANCHOVYNATHOLI.jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'KING FISH/ KADAL / ANJAL',
      'desc': 'KING FISH/ KADAL / ANJAL',
      'KGPrice': '1000',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'KING FISH KADAL  ANJAL.jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'RED SNAPPER/RANI/CHEMBALLI',
      'desc': 'RED SNAPPER/RANI/CHEMBALLI',
      'KGPrice': '2000',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'RED SNAPPERRANICHEMBALLI.jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'SEA CRAB',
      'desc': 'SEA CRAB',
      'KGPrice': '650',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'SEA CRAB.jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'BLUE CRAB',
      'desc': 'BLUE CRAB',
      'KGPrice': '1400',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'BLUE CRAB.jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'FLOWER SHRIMPS',
      'desc': 'FLOWER SHRIMPS',
      'KGPrice': '2000',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'FLOWER SHRIMPS.jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'PINK SHRIMP',
      'desc': 'PINK SHRIMP',
      'KGPrice': '1400',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'PINK SHRIMP.jpeg',
      'fishCategory' : 'SeaFish'
    });
    products.add({ 'name': 'BROWN SHRIMP/ WITCH SHRIMP (SEEGADI)',
      'desc': 'BROWN SHRIMP/ WITCH SHRIMP (SEEGADI)',
      'KGPrice': '1600',
      'PicDir': FISH_PIC_DIR,
      'subCategory': 'Fish',
      'PicName': 'BROWN SHRIMP WITCH SHRIMP (SEEGADI).jpeg',
      'fishCategory' : 'SeaFish'
    });
  }

  if(loadProductType.contains('Groceries')) {

  }
  if(loadProductType.contains('Service Provider')) {
    products.add({ 'name': 'Consultation / Inspection Charges',
      'desc': 'Consultation / Inspection Charges',
      'KGPrice': '350',
      'PicDir': SERVICES_PIC_DIR,
      'subCategory': 'HandyMan',
      'PicName': 'icons8-inspection-64.png',
    });
  }
  return products;
}