import 'package:latlong2/latlong.dart';

class LocationService {
  static LatLng getCityLatLng(String city) {
    switch (city) {
      case 'Unawatuna Beach':
      case 'Unawatuna':
        return LatLng(5.9882, 80.4504);
      case 'Mirissa Beach':
      case 'Mirissa':
        return LatLng(5.9489, 80.4546);
      case 'Arugam Bay Beach':
      case 'Arugam Bay':
        return LatLng(6.8380, 81.8305);
      case 'Tangalle Beach':
      case 'Tangalle':
        return LatLng(6.0231, 80.7919);
      case 'Nilaveli Beach':
      case 'Nilaveli':
        return LatLng(8.7184, 81.2289);
      case 'Hikkaduwa Beach':
      case 'Hikkaduwa':
        return LatLng(6.1400, 80.1000);
      case 'Trincomalee Beach':
      case 'Trincomalee':
        return LatLng(8.5711, 81.2335);
      case 'Bentota Beach':
      case 'Bentota':
        return LatLng(6.4281, 79.9973);
      case 'Pasikuda Beach':
      case 'Pasikuda':
        return LatLng(7.9759, 81.5682);
      case 'Kalpitiya Beach':
      case 'Kalpitiya':
        return LatLng(8.2430, 79.7721);
      case 'Weligama Beach':
      case 'Weligama':
        return LatLng(5.9723, 80.4298);

      case 'Kitulgala (White Water Rafting)':
        return LatLng(6.9870, 80.4232);
      case 'Ella (Zip Line)':
        return LatLng(6.8652, 81.0467);
      case 'Kitulgala':
        return LatLng(6.9870, 80.4232);
      case 'Ella':
        return LatLng(6.8652, 81.0467);
      case 'Knuckles Five Peaks Mountain':
        return LatLng(7.4469, 80.7764);
      case 'Pidurangala Rock':
        return LatLng(7.9567, 80.7599);
      case 'Sigiriya Rock Fortress':
      case 'Sigiriya':
        return LatLng(7.9570, 80.7603);
      case "Adam’s Peak":
        return LatLng(6.8094, 80.4994);
      case 'Pallewela Falls':
        return LatLng(6.6872, 80.6674);
      case 'Yala National Park':
        return LatLng(6.3663, 81.5183);
      case 'Gal Oya National Park':
        return LatLng(7.2564, 81.4982);
      case 'Babarakanda Ella':
        return LatLng(6.7434, 80.8521);
      case 'Lanka Ella':
        return LatLng(6.7125, 80.8631);
      case 'Sadun Ella':
        return LatLng(6.7505, 80.9439);

      case 'Wilpattu National Park':
        return LatLng(8.3039, 80.0920);
      case 'Bundala National Park':
        return LatLng(6.2069, 81.2546);
      case 'Minneriya National Park':
        return LatLng(8.0351, 80.9031);
      case 'Kaudulla National Park':
        return LatLng(8.1617, 80.9105);
      case 'Sinharaja Forest Reserve':
        return LatLng(6.4215, 80.4917);
      case 'Kumana National Park':
        return LatLng(6.5149, 81.6822);
      case 'Wasgamuwa National Park':
        return LatLng(7.6258, 80.9298);

      case 'Rambukkana to Kandy':
        return LatLng(7.2551, 80.3495); // Rambukkana
      case 'Kandy to Ella':
        return LatLng(7.2906, 80.6337); // Kandy
      case 'Ella to Badulla':
        return LatLng(6.8652, 81.0467); // Ella
      case 'Nuwara Eliya to Ella':
        return LatLng(6.9497, 80.7891); // Nuwara Eliya
      case 'Colombo to Badulla':
        return LatLng(6.9271, 79.8612); // Colombo
      case 'Galle to Matara':
        return LatLng(6.0328, 80.2170); // Galle
      case 'Bentota to Galle':
        return LatLng(6.4281, 79.9973); // Bentota
      case 'Nuwara Eliya to Haputale':
        return LatLng(6.9497, 80.7891); // Nuwara Eliya
      case 'Anuradhapura to Jaffna':
        return LatLng(8.3114, 80.4037); // Anuradhapura
      case 'Polgahawela to Anuradhapura':
        return LatLng(7.3352, 80.2014); // Polgahawela
      case 'Mahawa to Batticaloa':
        return LatLng(7.8259, 80.2944); // Mahawa

      case 'Dambulla Cave Temple':
        return LatLng(7.8567, 80.6495);
      case 'Polonnaruwa Ancient City':
        return LatLng(7.9390, 81.0188);
      case 'Anuradhapura Sacred City':
        return LatLng(8.3114, 80.4037);
      case 'Temple of the Tooth':
        return LatLng(7.2939, 80.6412);
      case 'Ruwanwelisaya':
        return LatLng(8.3443, 80.3964);
      case 'Jethawanaramaya':
        return LatLng(8.3521, 80.3929);
      case 'Mihintale':
        return LatLng(8.3506, 80.5099);
      case 'Yapahuwa Rock Fortress':
        return LatLng(7.7990, 80.3307);
      case 'Gal Viharaya':
        return LatLng(7.9359, 81.0019);
      case 'Aluvihare Rock Temple':
        return LatLng(7.4671, 80.6176);

      case 'Diyaluma Falls':
        return LatLng(6.7588, 81.0084);
      case 'Baker’s Falls':
        return LatLng(6.8091, 80.8017);
      case 'Aberdeen Falls':
        return LatLng(6.9280, 80.4922);
      case 'Laxapana Falls':
        return LatLng(6.9451, 80.4870);
      case "St. Clair’s Falls":
        return LatLng(6.9672, 80.6501);
      case 'Bomburu Ella':
        return LatLng(6.9011, 80.8731);
      case 'Bopath Ella Falls':
        return LatLng(6.8014, 80.2679);
      case 'Ramboda Falls':
        return LatLng(7.0492, 80.7394);
      case 'Duwili Ella':
        return LatLng(6.6056, 80.5931);
      case 'Geradi Ella':
        return LatLng(6.8021, 80.4794);
      case 'Sari Ella':
        return LatLng(6.7824, 80.8545);

      case "Adam’s Peak (Sri Pada)":
        return LatLng(6.8094, 80.4994);
      case 'Pidurutalagala':
        return LatLng(7.0008, 80.7829);
      case 'Kirigalpotta':
        return LatLng(6.7967, 80.7860);
      case 'Thotupola Kanda':
        return LatLng(6.8292, 80.8044);
      case 'Namunukula':
        return LatLng(6.8894, 81.0567);
      case 'Bible Rock':
        return LatLng(7.0800, 80.4817);
      case 'Gombaniya Peak':
        return LatLng(7.4645, 80.7722);
      case 'Knuckles Peak':
        return LatLng(7.4453, 80.7867);
      case 'Ritigala':
        return LatLng(8.3241, 80.6955);
      case 'Yakunge Kanda':
        return LatLng(7.0828, 80.4826);
      case 'Wamarapugala':
        return LatLng(6.8877, 81.0562);

      case 'Sinharaja Rainforest (Pitadeniya Entrance)':
        return LatLng(6.4168, 80.4620);
      case 'Makandawa Rainforest':
        return LatLng(6.9870, 80.4232);
      case 'Sinharaja Rainforest (Deniyaya Entrance)':
        return LatLng(6.3511, 80.5687);
      case 'Sinharaja Rainforest (Weddagala Entrance)':
        return LatLng(6.4378, 80.5011);
      case 'Knuckles Forest Reserve':
        return LatLng(7.4469, 80.7764);

      case 'Nuwara Eliya Tea Plantation':
        return LatLng(6.9497, 80.7891);
      case 'Pedro Tea Estate':
        return LatLng(6.9575, 80.8069);
      case 'Loolkandura Tea Estate':
        return LatLng(7.2128, 80.7083);
      case 'Blangoda Tea Plantations':
        return LatLng(6.6886, 80.6792);
      case 'Haputale Tea Plantations':
        return LatLng(6.7667, 80.9514);
      case 'Dambatenne Tea Factory':
        return LatLng(6.7917, 81.0219);
      case 'Mlesna Tea Castle':
        return LatLng(6.9170, 80.7534);
      case 'Bogawantalawa Valley':
        return LatLng(6.8121, 80.6699);

      case 'Horton Plains (World’s End)':
        return LatLng(6.8018, 80.8457);
      case 'Horton Plains':
        return LatLng(6.8018, 80.8457);
      case 'Devil’s Staircase':
        return LatLng(6.7994, 80.8567);
      case 'Dothalugala':
        return LatLng(7.3333, 80.8378);
      case 'Sinharaja Rainforest':
        return LatLng(6.4215, 80.4917);

      case 'Gangaramaya Temple':
        return LatLng(6.9279, 79.8612);
      case 'Jaya Sri Maha Bodhi':
        return LatLng(8.3467, 80.4097);
      case 'Kelaniya Raja Maha Vihara':
        return LatLng(6.9606, 79.9223);
      case 'Kataragama Temple':
        return LatLng(6.4161, 81.3316);
      case 'Lankaramaya':
        return LatLng(8.3567, 80.4036);
      case 'Isurumuniya Temple':
        return LatLng(8.3431, 80.3958);

      case 'Ancient City of Yapahuwa':
        return LatLng(7.8003, 80.3325);
      case 'Panduwasnuwara':
        return LatLng(7.5653, 80.0984);
      case 'Dambadeniya':
        return LatLng(7.4693, 80.1912);
      case 'Gampola':
        return LatLng(7.1647, 80.5703);
      case 'Aluvihare':
        return LatLng(7.4671, 80.6176);
      case 'Ratnapura':
        return LatLng(6.6828, 80.3993);
      case 'Nuwara Eliya':
        return LatLng(6.9497, 80.7891);
      case 'Haputale':
        return LatLng(6.7667, 80.9514);
      case 'Galle':
        return LatLng(6.0328, 80.2170);
      case 'Kandy':
        return LatLng(7.2906, 80.6337);
      case 'Badulla':
        return LatLng(6.9930, 81.0550);
      case 'Matara':
        return LatLng(5.9549, 80.5540);
      case 'Colombo':
        return LatLng(6.9271, 79.8612);
      case 'Colombo BIA Airport':
        return LatLng(7.1800, 79.9585);
      case 'BIA Airport':
        return LatLng(7.1800, 79.9585);
      case 'Colombo (BIA Airport)':
        return LatLng(7.1800, 79.9585);
      case 'Departure':
        return LatLng(7.1800, 79.9585);
      case 'BIA':
        return LatLng(7.1800, 79.9585);

      default:
        return LatLng(0, 0);
    }
  }
}
