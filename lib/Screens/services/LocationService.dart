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
      case 'Dambulla':
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
      case 'Aanda Ella Fall':
        return LatLng(6.7120206, 80.4609959);
      case 'Aberdeen Waterfall':
        return LatLng(6.9491486, 80.5015144);
      case 'Ahangama':
        return LatLng(5.9739747, 80.3621595);
      case 'Ahungalla':
        return LatLng(6.3132776, 80.0409178);
      case 'Alahana Pirivena':
        return LatLng(7.9619237, 81.003995);
      case 'Alankuda Casuarina Beach':
        return LatLng(8.0481352, 79.709916);
      case 'All Saints Church, Galle Church of Ceylon':
        return LatLng(6.027534, 80.2174478);
      case 'Alupotha Ella Waterfall':
        return LatLng(6.6182776, 80.4095082);
      case 'Aluthnuwara Rajamaha Viharaya , Aluthnuwara':
        return LatLng(7.2273193, 80.4852434);
      case 'Ambalangoda':
        return LatLng(6.2441521, 80.0590804);
      case 'Ambuluwawa Biodiversity Complex':
        return LatLng(7.1616275, 80.5471974);
      case 'Ambuluwawa Temple':
        return LatLng(7.1610613, 80.5470683);
      case 'Anawilundawa Wetland':
        return LatLng(7.7095947, 79.82127);
      case 'Angammedilla National Park':
        return LatLng(7.9254453, 80.9207737);
      case 'Anuradhapura New Town':
      case 'Anuradhapura':
        return LatLng(8.3227654, 80.4025767);
      case 'Arankale Buddhist Monastery':
        return LatLng(7.6396538, 80.4191984);
      case 'Archaeological Museum Mihintale':
        return LatLng(8.3555282, 80.5133253);
      case 'Archaeology Museum Kotte':
        return LatLng(6.8932482, 79.9050836);
      case 'Arthurs Seat View Point, Kandy':
        return LatLng(7.288817, 80.6398053);
      case 'Arugam Bay Beach':
        return LatLng(6.8404078, 81.8368478);
      case 'Arukuveli Beach':
        return LatLng(9.6241919, 80.1718869);
      case 'Athugala Viharaya':
        return LatLng(7.4842574, 80.3705497);
      case 'Auslink Hotel Walapane Sri Lanka':
        return LatLng(7.0950433, 80.8627914);
      case 'Bakers Falls':
        return LatLng(6.7927, 80.7895);
      case 'Balana Fort':
        return LatLng(7.2699125, 80.4956232);
      case 'Bambarakanda Falls':
        return LatLng(6.7733517, 80.8312138);
      case 'Bambarakiri Ella':
        return LatLng(7.495246, 80.6990011);
      case 'Baobab Tree Pallimunai, Mannar, Sri Lanka':
        return LatLng(8.9816707, 79.9231902);
      case 'Batadombalena':
        return LatLng(6.7765065, 80.3959493);
      case 'Bathalagoda Tank':
        return LatLng(7.531868, 80.450986);
      case 'Batticaloa Dutch Fort':
        return LatLng(7.7118126, 81.702124);
      case 'Batticaloa Gate':
        return LatLng(7.713625, 81.699643);
      case 'Batticaloa Lagoon':
        return LatLng(7.7143998, 81.70257);
      case 'Batticaloa Lighthouse':
        return LatLng(7.754836, 81.6853974);
      case 'Belihuloya':
        return LatLng(6.718399, 80.7740912);
      case 'Belilena Cave':
        return LatLng(7.0022371, 80.4357814);
      case 'Bentota Ganga':
        return LatLng(6.3957795, 80.0954164);
      case 'Bird Watching Tower':
        return LatLng(8.9570945, 79.9201626);
      case 'Black Galle Fort Zwart Bastion':
        return LatLng(6.0291295, 80.2192923);
      case 'Blue moon camping':
        return LatLng(8.2110065, 79.6941835);
      case 'Boat Trip Kalpitiya Dolphin Watching':
        return LatLng(8.2317679, 79.7679965);
      case 'Bogoda Raja Maha Viharaya':
        return LatLng(7.0080193, 80.9961595);
      case 'Bolgoda Lake':
        return LatLng(6.7712218, 79.9066763);
      case 'Bomburu Ella Waterfall':
        return LatLng(6.9473204, 80.8311903);
      case 'Bopath Falls':
        return LatLng(6.8017619, 80.3694222);
      case 'Bowatenna Reservoir':
        return LatLng(7.6714182, 80.6668997);
      case 'Box Stone pettigala':
        return LatLng(7.299619, 80.5632199);
      case 'British Queens House':
        return LatLng(6.0277701, 80.2177698);
      case 'Buddhangala Raja Maha Viharaya':
        return LatLng(7.3318361, 81.7036489);
      case 'Bundala National Park':
        return LatLng(6.1990863, 81.2104935);
      case 'Chariot Path':
        return LatLng(7.0844375, 80.7239375);
      case 'Chundikulam Bird Sanctuary':
        return LatLng(9.5141667, 80.5322222);
      case 'Cinnamon Bentota Beach':
        return LatLng(6.4249055, 79.9968753);
      case 'Colombo City Tour':
        return LatLng(6.8662122, 79.8831997);
      case 'Colombo Lotus Tower':
        return LatLng(6.9272949, 79.8584587);
      case 'Colombo National Museum':
        return LatLng(6.9099991, 79.8609032);
      case 'Coral Sanctuary Boat Ticket Issue Center':
        return LatLng(6.1373419, 80.0992534);
      case 'Corbetts Gap':
        return LatLng(7.3727646, 80.8408785);
      case 'Council Chamber':
        return LatLng(7.9428101, 81.001852);
      case 'Crocodile Lake Panama':
        return LatLng(6.7590091, 81.7860471);
      case 'Dakkhina Stupa Anuradhapura':
        return LatLng(8.3411599, 80.395259);
      case 'Dalada Maluva Polonnaruwa':
        return LatLng(7.9476343, 81.001233);
      case 'Dambulla':
        return LatLng(7.874217, 80.6511287);
      case 'Dambulla Royal Cave Temple and Golden Temple':
        return LatLng(7.8549141, 80.6505699);
      case 'Deegavapi Maha Stupa':
        return LatLng(7.2841152, 81.7865422);
      case 'Deegawapi Raja Maha Vihara':
        return LatLng(7.2847427, 81.7857885);
      case 'Dehiwala Zoological Gardens':
        return LatLng(6.8569811, 79.8744025);
      case 'Deliwala Kota Vehera Temple':
        return LatLng(7.3529846, 80.3780437);
      case 'Dematamal Viharaya':
        return LatLng(6.7539904, 81.2880131);
      case 'Devon Falls':
        return LatLng(6.9514077, 80.6300174);
      case 'Dhanaja Gem Museum':
        return LatLng(6.7041702, 80.3863567);
      case 'Dhushan ella':
        return LatLng(6.6317153, 80.3542309);
      case 'Diggala Campaign Side':
        return LatLng(6.8398993, 81.2723738);
      case 'Dimbulana hills Spot':
        return LatLng(7.0053879, 80.9536201);
      case 'Dimiyawa View Point':
        return LatLng(6.7073383, 80.3490515);
      case 'Divulgaskada Kuda Wewa':
        return LatLng(8.6612124, 80.5617788);
      case 'Diyagala Escape':
        return LatLng(6.7069924, 80.4390735);
      case 'Diyaluma Falls':
        return LatLng(6.7331443, 81.0314173);
      case 'Diyatha Uyana':
        return LatLng(6.904575, 79.9098313);
      case 'Diyawatanalla Waterfall':
        return LatLng(6.849332, 80.8589566);
      case 'Dry Zone Botanic Gardens, Hambantota':
        return LatLng(6.1533995, 81.066035);
      case 'Dunhinda Waterfall':
        return LatLng(7.0175417, 81.0635655);
      case 'Dutch Bay Beach':
        return LatLng(8.5733722, 81.2395084);
      case 'Dutch Cannon':
        return LatLng(7.7115771, 81.7024339);
      case 'Dutch Fort Jaffna':
        return LatLng(9.6620307, 80.0084252);
      case 'Dutch Museum':
        return LatLng(6.9359623, 79.851639);
      case 'Dutch Reformed Church, Matara':
        return LatLng(5.9447878, 80.5469267);
      case 'Duwili Ella Waterfall':
        return LatLng(6.6623191, 80.8658203);
      case 'Elephant Park':
        return LatLng(7.2764377, 81.7969824);
      case 'Elephant Point Beach':
        return LatLng(8.5360448, 81.2285746);
      case 'Elephant Transit Home':
        return LatLng(6.4266887, 80.8165359);
      case 'Ella Rock Trailhead':
        return LatLng(6.8578491, 81.0440226);
      case 'Fort Dew Guest House and Restaurant':
        return LatLng(6.0271673, 80.2152041);
      case 'Fort Entrance Old Gate':
        return LatLng(6.0281137, 80.218447);
      case 'Fort Frederick':
        return LatLng(8.5772776, 81.2432785);
      case 'Gal Oya Valley National Park':
        return LatLng(7.2285076, 81.4718387);
      case 'Galabedda Biso Pond':
        return LatLng(6.91683, 81.3875045);
      case 'Galegama Wewa':
        return LatLng(8.6351091, 80.5670909);
      case 'Galle':
        return LatLng(6.0328948, 80.2167912);
      case 'Galle Dutch Fort':
        return LatLng(6.0304592, 80.2150207);
      case 'Galle Fort Attractions and Jumpers Sri Lanka':
        return LatLng(6.0304644, 80.2150237);
      case 'Galle Lighthouse':
        return LatLng(6.0245613, 80.2193661);
      case 'Gangaramaya Temple':
        return LatLng(6.9167145, 79.8566456);
      case 'Geradi Ella Falls':
        return LatLng(6.9635967, 80.9700842);
      case 'Glassaugh Falls':
        return LatLng(6.9465776, 80.7372359);
      case 'Hakgala Botanical Garden':
        return LatLng(6.9265849, 80.8215284);
      case 'Haliela , Sri Lanka':
        return LatLng(6.973818, 81.0379761);
      case 'Hambantota Beach':
        return LatLng(6.1279932, 81.1272036);
      case 'Haputale':
        return LatLng(6.7654136, 80.9525655);
      case 'Hatadage':
        return LatLng(7.9478635, 81.0013018);
      case 'Hatale Mini Worlds End':
        return LatLng(7.3826346, 80.722532);
      case 'Hathbamba Ella Waterfall':
        return LatLng(6.6350499, 80.3591021);
      case 'Hathbili Ella Falls':
        return LatLng(6.6542402, 80.4705553);
      case 'Hettipola wewa':
        return LatLng(7.601516, 80.0796619);
      case 'Heyna camping site':
        return LatLng(6.2073401, 81.2720141);
      case 'Hidden Water fall Tiny Ella':
        return LatLng(7.278051, 80.630203);
      case 'Hikka Tranz by Cinnamon':
        return LatLng(6.1317075, 80.1011004);
      case 'Hikkaduwa':
        return LatLng(6.1394676, 80.1062861);
      case 'Hikkaduwa Beach':
        return LatLng(6.1377266, 80.0990596);
      case 'Hirigalketiya waterfall':
        return LatLng(6.6360402, 80.4489898);
      case 'Hiriketiya Beach':
        return LatLng(5.9623577, 80.706811);
      case 'Horton Plains National Park':
        return LatLng(6.809446, 80.8023333);
      case 'Huluganga Ella Waterfall':
        return LatLng(7.4009935, 80.7423197);
      case 'Hundukata':
        return LatLng(6.742942, 80.447135);
      case 'Hunnasgiriya Water Fall':
        return LatLng(7.4018005, 80.6898511);
      case 'Hurulu Eco Park Wild Elephant Safari':
        return LatLng(8.0584389, 80.7702566);
      case 'Ice fall view point':
        return LatLng(6.945866, 80.7388536);
      case 'Independence Memorial Museum':
        return LatLng(6.9041085, 79.8676062);
      case 'International Buddhist Museum':
        return LatLng(7.2940263, 80.6418502);
      case 'Isurumuniya Temple':
        return LatLng(8.3346006, 80.3906446);
      case 'Jaffna Lagoon Area':
        return LatLng(9.6576092, 80.004428);
      case 'Jaffna Public Library':
        return LatLng(9.6621275, 80.0117309);
      case 'Jana Kala Kendraya':
        return LatLng(6.8901777, 79.9217188);
      case 'Jaya Sri Maha Bodhi':
        return LatLng(8.3448577, 80.397303);
      case 'Jayanthi Wewa Hot Spring':
        return LatLng(7.1408484, 81.5523965);
      case 'Jungle Beach':
        return LatLng(6.0186943, 80.2394104);
      case 'Kadawatha Wewa':
        return LatLng(8.6621548, 80.541028);
      case 'Kalametiya Bird Sanctuary Bird Watching Ecotourism':
        return LatLng(6.0824603, 80.9293944);
      case 'Kalmunai Point':
        return LatLng(8.0633247, 79.7550827);
      case 'Kalpitiya':
        return LatLng(8.2295281, 79.7596142);
      case 'Kalpitiya Dutch Church':
        return LatLng(8.2373172, 79.7647655);
      case 'Kalpitiya Lagoon':
        return LatLng(8.2412725, 79.7441936);
      case 'Kanakarayan Kulam':
        return LatLng(9.0559875, 80.5092656);
      case 'Kandalama':
        return LatLng(7.8884985, 80.7103532);
      case 'Kandy':
        return LatLng(7.2905715, 80.6337262);
      case 'Kandy City Centre':
        return LatLng(7.2920223, 80.6371148);
      case 'Kandy Lake':
        return LatLng(7.2912017, 80.6420565);
      case 'Kandy Lake View Point':
        return LatLng(7.29289, 80.6378493);
      case 'Kandy National Museum':
        return LatLng(7.2933389, 80.6420168);
      case 'Kandyan Cultural Centre':
        return LatLng(7.2920019, 80.6423871);
      case 'Kanneliya National Rain Forest Reserve':
        return LatLng(6.2576416, 80.3596211);
      case 'Kanniya Hot Water Springs':
        return LatLng(8.6044979, 81.1713376);
      case 'Kataragama':
        return LatLng(6.4135463, 81.3325679);
      case 'Kattukkarai Kulam':
        return LatLng(8.8627469, 80.0157274);
      case 'Katugas Ella Waterfall':
        return LatLng(6.7050077, 80.4019678);
      case 'Katukeliyawa Wewa':
        return LatLng(8.6815884, 80.5708941);
      case 'Kelaniya Raja Maha Viharaya':
        return LatLng(6.951826, 79.9184698);
      case 'King Sangiliyans Statue':
        return LatLng(9.6742111, 80.0351267);
      case 'Kiranchi Beach':
        return LatLng(9.3107049, 80.1127062);
      case 'Kiri Vehera':
        return LatLng(7.9632729, 81.0036212);
      case 'Kirindi Ella Waterfall':
        return LatLng(6.6422444, 80.5644469);
      case 'Kiriwalketiya waterfall':
        return LatLng(6.637441, 80.4557783);
      case 'Kitulgala':
        return LatLng(6.9897845, 80.4270885);
      case 'Knuckles':
        return LatLng(7.4423921, 80.7809609);
      case 'Knuckles Forest Reserve':
        return LatLng(7.45016, 80.7879407);
      case 'Koggala':
        return LatLng(6.000704, 80.3352364);
      case 'Koggala Beach':
        return LatLng(5.992272, 80.3106907);
      case 'Kokkilai Beach':
        return LatLng(9.0645944, 80.9187057);
      case 'Korathota Royal Temple':
        return LatLng(6.915038, 80.0021349);
      case 'Kotte Rajamaha Vihara':
        return LatLng(6.8810081, 79.9047497);
      case 'Kuda Meegaskada Wewa':
        return LatLng(8.6677438, 80.5716299);
      case 'Kudawa Beach Kalpitiya':
        return LatLng(8.2273054, 79.7281564);
      case 'Kumana National Park':
        return LatLng(6.5729598, 81.6692532);
      case 'Lahugala Magul Maha Viharaya':
        return LatLng(6.8673471, 81.7366519);
      case 'Lake side cabana':
        return LatLng(8.5742414, 81.2205383);
      case 'Lankavatara Beach':
        return LatLng(6.0736968, 80.9263157);
      case 'Laxapana Falls':
        return LatLng(6.8996007, 80.5010409);
      case 'Leisure World':
        return LatLng(6.9167, 80.0667);
      case 'Limestone Caves':
        return LatLng(9.8208594, 80.1445444);
      case 'Lionel Wendt Art Centre':
        return LatLng(6.9068713, 79.8606262);
      case 'Lions Mouth Rock Kadugannawa':
        return LatLng(7.2538553, 80.5065411);
      case 'Lissana gala':
        return LatLng(6.6199775, 80.3737443);
      case 'Lotus Pond Ancient Nelum Pokuna':
        return LatLng(7.9748656, 81.0040111);
      case 'Lotus Pond Nelum pokuna II II':
        return LatLng(7.9838244, 81.0038763);
      case 'Lunuganga':
        return LatLng(6.4033838, 80.0218791);
      case 'Madola Ella':
        return LatLng(6.621315, 80.4815627);
      case 'Madu Ganga':
        return LatLng(6.3140994, 80.0916463);
      case 'Madunagala Hot Water Spring':
        return LatLng(6.2536301, 80.9817108);
      case 'Maha Meegaskada Wewa':
        return LatLng(8.6722842, 80.5746271);
      case 'Maha Oya Hot Water Springs':
        return LatLng(7.5521811, 81.3530409);
      case 'Maha Viharaya, Anuradhapura':
        return LatLng(8.3446885, 80.3965833);
      case 'Mahakarambewa Wewa':
        return LatLng(8.0347222, 79.9422222);
      case 'Mahamevnawa Buddhist Monastery Galle':
        return LatLng(6.0414191, 80.2738168);
      case 'Mahamevnawa Buddhist Monastery Polgahawela':
        return LatLng(7.3417595, 80.2536578);
      case 'Makandawa Conservation Center Makandawa Forest':
        return LatLng(6.9909196, 80.4053683);
      case 'Maligawila Buddha Statue':
        return LatLng(6.7283835, 81.3523636);
      case 'Mandathivu Beach':
        return LatLng(9.6035805, 80.0002593);
      case 'Manelwatta Temple':
        return LatLng(6.9449211, 79.9513614);
      case 'Mannar Dutch Fort':
        return LatLng(8.9758559, 79.9169964);
      case 'Marakolliya':
        return LatLng(6.0613722, 80.818401);
      case 'Marakolliya Beach':
        return LatLng(6.0422218, 80.823073);
      case 'Maritime Museum':
        return LatLng(6.028025, 80.2180559);
      case 'Martin Wickramasinghe Folk Museum':
        return LatLng(5.989937, 80.328019);
      case 'Mayan Water Park':
        return LatLng(7.0688943, 79.9022359);
      case 'Meemure':
        return LatLng(7.4326453, 80.8460822);
      case 'Mekichchawa Wewa':
        return LatLng(8.6611522, 80.542828);
      case 'Menik Ganga Dunhinda Falls':
        return LatLng(6.8484252, 81.2383577);
      case 'Midigama Right':
        return LatLng(5.9648146, 80.3836423);
      case 'Mihintale':
        return LatLng(8.35, 80.5);
      case 'Millella Small Waterfall':
        return LatLng(7.4327001, 80.4044365);
      case 'Minneriya National Park':
        return LatLng(8.0156443, 80.8446703);
      case 'Mirisawetiya':
        return LatLng(8.3449317, 80.3889742);
      case 'Mirissa':
        return LatLng(5.948262, 80.4715866);
      case 'Mirissa Beach':
        return LatLng(5.9447028, 80.4591608);
      case 'Mirissa whale Explorers':
        return LatLng(5.947407, 80.451632);
      case 'Monument of Victory':
        return LatLng(9.3219796, 80.7261394);
      case 'Moon Plains':
        return LatLng(6.9523269, 80.7964041);
      case 'Mullaitivu Beach':
        return LatLng(9.271618, 80.8194644);
      case 'Muthiyangana Raja Maha Vihara':
        return LatLng(6.9842184, 81.0613561);
      case 'N Uyana Forest Monastery':
        return LatLng(7.7387408, 80.5159067);
      case 'Nallur Kandaswamy Devasthanam':
        return LatLng(9.6743625, 80.0298281);
      case 'Nanu Oya Water Falls, Nanu Oya':
        return LatLng(6.9451534, 80.7387815);
      case 'Narangala Golden Mountain':
        return LatLng(7.0412169, 81.0215229);
      case 'Narangala N view point':
        return LatLng(7.025305, 80.9936217);
      case 'National Gallery of Art':
        return LatLng(6.911458, 79.860176);
      case 'National Museum Galle':
        return LatLng(6.0289175, 80.2168789);
      case 'National Railway Museum':
        return LatLng(7.2576222, 80.5208309);
      case 'National Shrine of Our Lady of Madhu':
        return LatLng(8.8548578, 80.202911);
      case 'National Spice Garden of Sri Lanka':
        return LatLng(7.4529379, 80.6410087);
      case 'Nawanalla waterfall':
        return LatLng(6.663765, 80.3358393);
      case 'Negombo':
        return LatLng(7.2055208, 79.8512562);
      case 'Negombo Lagoon':
        return LatLng(7.1580045, 79.8464804);
      case 'Neithal Eco Park Mandaitivu':
        return LatLng(9.6233803, 80.0039303);
      case 'Neithal Park':
        return LatLng(9.6437491, 80.1008993);
      case 'Nelum Pokuna Theatre':
        return LatLng(6.9108032, 79.8634467);
      case 'Nelung Arts Centre':
        return LatLng(6.9170317, 79.8601663);
      case 'Neluwa Doovili Ella':
        return LatLng(6.3912983, 80.3922753);
      case 'New Kallady Bridge Batticaloa':
        return LatLng(7.7192362, 81.707114);
      case 'New Kallady bridge view point':
        return LatLng(7.7190874, 81.7047208);
      case 'Nilavarai, Natural underground water well':
        return LatLng(9.7543792, 80.0882614);
      case 'Nilaveli Beach':
        return LatLng(8.7003072, 81.19205);
      case 'Nine Arches Bridge':
        return LatLng(6.8768151, 81.0608465);
      case 'Nissanka Lata Mandapa':
        return LatLng(7.9475196, 81.0011315);
      case 'Nuraicholai Casuarina Beach , KasaKale':
        return LatLng(8.0460703, 79.7107844);
      case 'Nuwara Eliya':
        return LatLng(6.9497166, 80.7891068);
      case 'Nuwara Eliya Golf Club':
        return LatLng(6.971737, 80.7657307);
      case 'Nuwara Eliya Mountains view point':
        return LatLng(6.9834547, 80.7504763);
      case 'Nuwara Wewa View Point':
        return LatLng(8.336791, 80.416116);
      case 'Okanda Beach':
        return LatLng(6.6501404, 81.7761872);
      case 'Our Lady of Refuge OLR Church, Jaffna':
        return LatLng(9.6631455, 80.018255);
      case 'Paduwasnuwara Museum':
        return LatLng(7.6052096, 80.1015032);
      case 'Palace of King Nishshanka Malla':
        return LatLng(7.943796, 80.9980073);
      case 'Pallikuda Beach':
        return LatLng(9.4841224, 80.1857761);
      case 'Palugollewa Wewa':
        return LatLng(8.6522733, 80.5562767);
      case 'Panakala Lagoon':
        return LatLng(6.7326081, 81.7937386);
      case 'Panama Wewa':
        return LatLng(6.7545084, 81.7733721);
      case 'Pandalawa Ella':
        return LatLng(6.7377419, 80.399637);
      case 'Panduwasnuwara Kingdom':
        return LatLng(7.6033584, 80.1025672);
      case 'Parakrama Samudraya':
        return LatLng(7.9404788, 80.9978484);
      case 'Parappudva Island Temple':
        return LatLng(6.1115676, 80.1383425);
      case 'Paravagale ampara':
        return LatLng(7.2954816, 81.6095117);
      case 'Pareiyan Ella Falls':
        return LatLng(6.8498703, 81.237553);
      case 'Parewi Duwa Temple':
        return LatLng(5.9413814, 80.5492554);
      case 'Pasikuda Beach':
        return LatLng(7.9299939, 81.5611852);
      case 'Peacocks Rock':
        return LatLng(6.13578, 81.1444056);
      case 'Pearl Bay':
        return LatLng(6.737, 79.9853);
      case 'Peradeniya':
        return LatLng(7.2698653, 80.593833);
      case 'Pesalai Beach':
        return LatLng(9.0911748, 79.8100761);
      case 'Pidurangala Rock':
        return LatLng(7.9663886, 80.7618379);
      case 'Piduruthalagala Conservation Forest':
        return LatLng(7.0216667, 80.7561111);
      case 'Pigeon Island':
        return LatLng(8.721837, 81.204071);
      case 'Pinnawala':
        return LatLng(7.3014952, 80.3867417);
      case 'Pinnawala Elephant Orphanage':
        return LatLng(7.3008545, 80.388855);
      case 'Pitawala Nature Trail':
        return LatLng(7.5489826, 80.751473);
      case 'Pitawala Patana Trail':
        return LatLng(7.546518, 80.746873);
      case 'Polonnaruwa':
        return LatLng(7.9403384, 81.0187984);
      case 'Polonnaruwa Ancient City':
        return LatLng(7.9459425, 81.0003294);
      case 'Polonnaruwa Sivan Kovil':
        return LatLng(7.9462875, 81.0013281);
      case 'Porawagala Viewpoint':
        return LatLng(6.8301766, 81.0127674);
      case 'Port City Colombo':
        return LatLng(6.9378036, 79.8368426);
      case 'Potgul Temple':
        return LatLng(7.9245435, 80.9945329);
      case 'Pudumala camp site':
        return LatLng(7.0468776, 81.0045657);
      case 'Rajanawa Waterfall':
        return LatLng(6.6546971, 80.4413698);
      case 'Ram setu':
        return LatLng(9.079482, 79.699222);
      case 'Ramboda Falls':
        return LatLng(7.0545692, 80.705331);
      case 'Ranmasu Uyana Royal Park':
        return LatLng(8.3384222, 80.3898477);
      case 'Rathmalwetiya Wewa':
        return LatLng(8.6488318, 80.5454814);
      case 'Ravan Ella Waterfall':
        return LatLng(6.9591791, 80.8547844);
      case 'Ravanas Cave':
        return LatLng(6.8644786, 81.0486417);
      case 'Rawana Abyss':
        return LatLng(8.5820184, 81.2453797);
      case 'Rekawa Beach':
        return LatLng(6.0431807, 80.8606343);
      case 'Richmond Castle':
        return LatLng(6.6015528, 79.9753241);
      case 'Ridiyagama Safari Park':
        return LatLng(6.2468436, 80.9824649);
      case 'Ridiyagama waterfront':
        return LatLng(6.2092173, 80.968159);
      case 'Rillamba Surf Point':
        return LatLng(6.0328948, 80.2167912);
      case 'Ritigala':
        return LatLng(8.1091667, 80.6547222);
      case 'Ritigala Strict Natural Reserve':
        return LatLng(8.1166667, 80.65);
      case 'Riverston':
        return LatLng(7.526674, 80.7370517);
      case 'Royal Botanic Gardens, Peradeniya':
        return LatLng(7.2681893, 80.5966332);
      case 'Royal Colombo Golf Club':
        return LatLng(6.9052268, 79.8841999);
      case 'Royal Palace Park':
        return LatLng(7.290271, 80.6373742);
      case 'Royal Palace of King Maha Parakramabahu':
        return LatLng(7.9425092, 81.0007671);
      case 'Ruhunu Maha Kataragama Dewalaya':
        return LatLng(6.4185071, 81.3332777);
      case 'Ruins of Poonakary Fort':
        return LatLng(9.5033332, 80.2120936);
      case 'Ruins of an ancient building':
        return LatLng(7.961255, 81.0002295);
      case 'Rumassala South Beach':
        return LatLng(6.0184625, 80.2354871);
      case 'Ruwanweli Maha Seya':
        return LatLng(8.3498926, 80.3965558);
      case 'SUNDARAM BEACH':
        return LatLng(9.6227176, 80.0052386);
      case 'Samadhi Buddha Statue':
        return LatLng(8.3698774, 80.3981853);
      case 'Sambodhi Pagoda Temple':
        return LatLng(6.9383932, 79.8420285);
      case 'Sandaraja Wana Arana':
        return LatLng(7.1182691, 80.4120138);
      case 'Sangupiddi Bridge':
        return LatLng(9.5736294, 80.1992706);
      case 'Sathmahal Prasadaya':
        return LatLng(7.9479524, 81.0018178);
      case 'Sayansi Beach':
        return LatLng(9.647101, 80.3821795);
      case 'Sea Turtle Hatchery Habaraduwa':
        return LatLng(5.9937023, 80.3041743);
      case 'Seetha Eliya':
        return LatLng(6.9332079, 80.8102678);
      case 'Seethawaka Wet Zone Botanical Gardens':
        return LatLng(6.892941, 80.1717612);
      case 'Sigiriya':
        return LatLng(7.9570327, 80.760257);
      case 'Single Tree Hill':
        return LatLng(6.9577851, 80.7625008);
      case 'Sinharaja Forest Reserve':
        return LatLng(6.4069908, 80.4600266);
      case 'Sinharaja Rain forest, Waddagala, Kalawana':
        return LatLng(6.4360351, 80.4195879);
      case 'Siri Gautama Sambuddharaja Maligawa':
        return LatLng(7.3415841, 80.253971);
      case 'Snake Farm Weligama Traditional Farm':
        return LatLng(6.0139105, 80.4737256);
      case 'Somawathiya National Park':
        return LatLng(8.1692559, 81.2078164);
      case 'Spa Ceylon Heritage Spa Boutique II Galle Fort':
        return LatLng(6.0262575, 80.2168828);
      case 'Sr Vijayrma Ancient Temple':
        return LatLng(6.2452686, 80.0575088);
      case 'Sri Dalada Maligawa':
        return LatLng(7.293609, 80.641325);
      case 'Sri Lanka Planetarium':
        return LatLng(6.9006972, 79.8628492);
      case 'Sri Pada Adams Peak':
        return LatLng(6.809643, 80.4993882);
      case 'Sripada Peak Wilderness Sanctuary':
        return LatLng(6.817866, 80.4892398);
      case 'St. Anthonys Shrine, Kochchikade.':
        return LatLng(6.9468412, 79.856253);
      case 'St. Clair Falls':
        return LatLng(6.951743, 80.648049);
      case 'St. Marys Cathedral':
        return LatLng(6.0359972, 80.2126917);
      case 'St. Marys Cathedral Jaffna':
        return LatLng(9.6562359, 80.0228986);
      case 'St. Marys Church':
        return LatLng(7.210453, 79.8372024);
      case 'Star Gate Ranmasu Uyana':
        return LatLng(8.3372385, 80.3898503);
      case 'Sunflower Arts Crafts':
        return LatLng(6.4271466, 80.0085066);
      case 'SunsetIsland':
        return LatLng(7.1998988, 81.5195008);
      case 'Surathali Ella':
        return LatLng(6.7457754, 80.8288354);
      case 'Swarnagiri Maha Viharaya Single Tree Temple':
        return LatLng(6.9550559, 80.766179);
      case 'Swastha Ayurveda':
        return LatLng(6.1320792, 80.1012744);
      case 'Talaimannar Lighthouse':
        return LatLng(9.1074228, 79.7310609);
      case 'Tangalle':
        return LatLng(6.0243383, 80.7940726);
      case 'Tangalle Beach':
        return LatLng(6.0227264, 80.8008358);
      case 'Tantirimale Rajamaha Viharaya':
        return LatLng(8.5736017, 80.2558288);
      case 'Thabbowa Wewa View Point':
        return LatLng(8.0599254, 79.9679445);
      case 'Thalawila Beach':
        return LatLng(8.1114274, 79.7018623);
      case 'Thambiluvil Beach':
        return LatLng(7.125067, 81.8572972);
      case 'Thandiyadi Lagoon':
        return LatLng(7.0519269, 81.8457198);
      case 'The Shrine of Our Lady of Matara':
        return LatLng(5.9432239, 80.5519762);
      case 'Thepulangoda Waterfall':
        return LatLng(6.7283412, 80.393811);
      case 'Thummulla Wewa':
        return LatLng(6.5806614, 81.7364516);
      case 'Thuparama Image House Image of Boddhisathwa':
        return LatLng(7.9477758, 81.0008934);
      case 'Thuparamaya':
        return LatLng(8.3553447, 80.3964751);
      case 'Tissamaharama Raja Maha Vihara':
        return LatLng(6.2801801, 81.2900771);
      case 'Tour With Dash':
        return LatLng(6.043131, 80.2183189);
      case 'Trincomalee':
        return LatLng(8.5873638, 81.2152121);
      case 'Trincomalee Beach':
        return LatLng(8.5733464, 81.2392774);
      case 'Trincomalee Harbour':
        return LatLng(8.5333333, 81.25);
      case 'Turtle Watch Rekawa':
        return LatLng(6.0462588, 80.8557179);
      case 'Turtle Watching point':
        return LatLng(8.2117941, 79.6949178);
      case 'Udawalawa':
        return LatLng(6.4184828, 80.823938);
      case 'Udawalawe National Park':
        return LatLng(6.4746288, 80.876319);
      case 'Udawatta Kele Sanctuary':
        return LatLng(7.2988782, 80.6424033);
      case 'Uduwathura Lake':
        return LatLng(6.0259129, 80.4786271);
      case 'Umari Lagoon':
        return LatLng(7.0448379, 81.8595828);
      case 'Unawatuna':
        return LatLng(6.0174469, 80.2488596);
      case 'Unawatuna Beach':
        return LatLng(6.0096861, 80.248424);
      case 'Upper Diyaluma Waterfall':
        return LatLng(6.7348278, 81.0324472);
      case 'Uppuveli':
        return LatLng(8.6015618, 81.2195241);
      case 'Uppuveli Beach':
        return LatLng(8.6079558, 81.2200129);
      case 'Ussangoda National Park':
        return LatLng(6.0989204, 80.9883434);
      case 'Vankalai Bird Sanctuary':
        return LatLng(8.9199943, 79.9328917);
      case 'Vankalaippadu Beach':
        return LatLng(9.0813821, 79.8434642);
      case 'Vatadage':
        return LatLng(7.9473653, 81.0013068);
      case 'Velgam Vehera Buddhist Temple':
        return LatLng(8.6471866, 81.1696845);
      case 'Ventura Beach':
        return LatLng(6.4234707, 79.9953199);
      case 'Victor Hasselblad Sea Turtle Research And Conservation Centre':
        return LatLng(6.3337051, 80.0279064);
      case 'Viharamahadevi Park':
        return LatLng(6.9133907, 79.8617401);
      case 'Wasgamuwa National Park':
        return LatLng(7.7532419, 80.9207737);
      case 'Watawala Ella':
        return LatLng(6.6285696, 80.360297);
      case 'Water World Aquarium':
        return LatLng(6.9441709, 79.9423889);
      case 'Wedikkarayage Wewa':
        return LatLng(8.6691361, 80.5408233);
      case 'Weherahena Poorwarama Rajamaha Viharaya Matara':
        return LatLng(5.953038, 80.575286);
      case 'Weli Oya Bridge':
        return LatLng(6.7674876, 80.8468142);
      case 'Weligama Beach surf and stay':
        return LatLng(5.9724858, 80.4357139);
      case 'Wilpattu National Park':
        return LatLng(8.4581819, 80.0518306);
      case 'Windmill':
        return LatLng(9.6051784, 80.1650289);
      case 'Wirawila Tissa Sanctuary':
        return LatLng(6.3, 81.25);
      case 'Yala Green Safari':
        return LatLng(6.2774947, 81.2670255);
      case 'Yala National Park':
        return LatLng(6.4639613, 81.4718847);
      case 'Yapahuwa Rock Fortress':
        return LatLng(7.8178707, 80.3116203);
      case 'jungle muru safari':
        return LatLng(6.4384812, 80.8894497);
      case 'riapla Mask Museum':
        return LatLng(6.2412718, 80.0506997);
      case 'rumassala':
        return LatLng(6.0328948, 80.2167912);

      default:
        return LatLng(0, 0);
    }
  }
}
