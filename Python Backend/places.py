class Places:
    def __init__(self):
        self.places = {
            'Unawatuna Beach': ['Beaches'],
            'Mirissa Beach': ['Beaches'],
            'Arugam Bay': ['Beaches'],
            'Tangalle Beach': ['Beaches'],
            'Nilaveli Beach': ['Beaches'],
            'Hikkaduwa Beach': ['Beaches'],
            'Trincomalee Beach': ['Beaches'],
            'Bentota Beach': ['Beaches'],
            'Pasikuda Beach': ['Beaches'],
            'Kalpitiya Beach': ['Beaches'],
            'Weligama Beach': ['Beaches'],

            'Kitulgala (White Water Rafting)': ['Adventure'],
            'Ella (Zip Line)': ['Adventure'],
            'Knuckles Five Peaks Mountain': ['Adventure', 'Mountains'],
            'Sigiriya Rock Fortress': ['Cultural'],
            'Adam’s Peak': ['Mountains'],
            'Pallewela Falls': ['Adventure'],
            'Yala National Park': ['Wildlife', 'Adventure'],
            'Gal Oya National Park': ['Wildlife', 'Adventure'],
            'Babarakanda Ella': ['Adventure', 'Waterfalls'],
            'Lanka Ella': ['Adventure', 'Waterfalls'],
            'Sadun Ella': ['Adventure', 'Waterfalls'],

            'Wilpattu National Park': ['Wildlife'],
            'Bundala National Park': ['Wildlife'],
            'Kaudulla National Park': ['Wildlife'],
            'Sinharaja Forest Reserve': ['Wildlife', 'Rainforests'],
            'Kumana National Park': ['Wildlife'],
            'Wasgamuwa National Park': ['Wildlife'],

            'Rambukkana to Kandy': ['Scenic Train Rides'],
            'Kandy to Ella': ['Scenic Train Rides'],
            'Ella to Badulla': ['Scenic Train Rides'],
            'Nuwara Eliya to Ella': ['Scenic Train Rides'],
            'Colombo to Badulla': ['Scenic Train Rides'],
            'Galle to Matara': ['Scenic Train Rides'],
            'Bentota to Galle': ['Scenic Train Rides'],
            'Nuwara Eliya to Haputale': ['Scenic Train Rides'],
            'Anuradhapura to Jaffna': ['Scenic Train Rides'],
            'Polgahawela to Anuradhapura': ['Scenic Train Rides'],
            'Mahawa to Batticaloa': ['Scenic Train Rides'],

            'Dambulla Cave Temple': ['Cultural'],
            'Polonnaruwa Ancient City': ['Cultural'],
            'Anuradhapura Sacred City': ['Cultural'],
            'Temple of the Tooth': ['Cultural'],
            'Ruwanwelisaya': ['Cultural'],
            'Jethawanaramaya': ['Cultural'],
            'Mihintale': ['Cultural'],
            'Yapahuwa Rock Fortress': ['Cultural'],
            'Gal Viharaya': ['Cultural'],
            'Aluvihare Rock Temple': ['Cultural'],

            'Diyaluma Falls': ['Waterfalls'],
            'Baker’s Falls': ['Waterfalls'],
            'Aberdeen Falls': ['Waterfalls'],
            'Laxapana Falls': ['Waterfalls'],
            'St. Clair’s Falls': ['Waterfalls'],
            'Bomburu Ella': ['Waterfalls'],
            'Bopath Ella Falls': ['Waterfalls'],
            'Ramboda Falls': ['Waterfalls'],
            'Duwili Ella': ['Waterfalls'],
            'Geradi Ella': ['Waterfalls'],
            'Sari Ella': ['Waterfalls'],

            'Adam’s Peak (Sri Pada)': ['Mountains'],
            'Pidurutalagala': ['Mountains'],
            'Kirigalpotta': ['Mountains'],
            'Thotupola Kanda': ['Mountains'],
            'Namunukula': ['Mountains'],
            'Bible Rock': ['Mountains'],
            'Gombaniya Peak': ['Mountains'],
            'Knuckles Peak': ['Mountains'],
            'Ritigala': ['Mountains'],
            'Yakunge Kanda': ['Mountains'],
            'Wamarapugala': ['Mountains'],

            'Makandawa Rainforest': ['Rainforests'],
            'Knuckles Forest Reserve': ['Rainforests'],

            'Nuwara Eliya Tea Plantation': ['Tea Plantations'],
            'Pedro Tea Estate': ['Tea Plantations'],
            'Loolkandura Tea Estate': ['Tea Plantations'],
            'Blangoda Tea Plantations': ['Tea Plantations'],
            'Haputale Tea Plantations': ['Tea Plantations'],
            'Dambatenne Tea Factory': ['Tea Plantations'],
            'Mlesna Tea Castle': ['Tea Plantations'],
            'Bogawantalawa Valley': ['Tea Plantations'],

            'Horton Plains (World’s End)': ['Hiking Trails', 'Mountains'],
            'Devil’s Staircase': ['Hiking Trails', 'Mountains'],
            'Dothalugala Trail': ['Hiking Trails', 'Mountains'],
            'Sinharaja Rainforest Trails': ['Hiking Trails', 'Rainforests'],

            'Gangaramaya Temple': ['Cultural'],
            'Jaya Sri Maha Bodhi': ['Cultural'],
            'Kelaniya Raja Maha Vihara': ['Cultural'],
            'Kataragama Temple': ['Cultural'],
            'Lankaramaya': ['Cultural'],
            'Isurumuniya Temple': ['Cultural'],

            'Ancient City of Yapahuwa': ['Cultural'],
            'Panduwasnuwara': ['Cultural'],
            'Dambadeniya': ['Cultural'],
            'Gampola': ['Cultural'],
            'Aluvihare': ['Cultural'],
            'Ratnapura': ['Cultural']
        }

    def filter_places_by_categories(self, interested_categories):
        filtered_places = []
        for place, categories in self.places.items():
            if any(category in categories for category in interested_categories):
                filtered_places.append(place)
        return filtered_places