import os
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import FAISS
from langchain_huggingface import HuggingFaceEmbeddings
from langchain.schema import Document

def create_vector_db(resource_folder, subfolder, filename):
    script_dir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    file_path = os.path.join(script_dir, "RAG_Documents", resource_folder, subfolder, filename)
    
    try:
        with open(file_path, "r", encoding="utf-8") as file:
            text = file.read()
        print(f"File {filename} read successfully")
    except Exception as e:
        print(f"Error reading file: {e}")
        return None
    
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=2000, chunk_overlap=200)
    chunks = text_splitter.split_text(text)
    
    embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")
    vector_store = FAISS.from_texts(chunks, embeddings)
    return vector_store

def create_vector_db_from_folder(resource_folder, subfolder=None):
    script_dir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    base_path = os.path.join(script_dir, "RAG_Documents", resource_folder)
    
    if subfolder:
        folder_path = os.path.join(base_path, subfolder)
    else:
        folder_path = base_path
    
    all_text = ""
    for filename in os.listdir(folder_path):
        if filename.endswith(".txt"):
            file_path = os.path.join(folder_path, filename)
            try:
                with open(file_path, "r", encoding="utf-8") as file:
                    all_text += file.read() + "\n\n"
            except Exception as e:
                print(f"Error reading file {filename}: {e}")
    
    if not all_text:
        print(f"No text files found or read in the folder {folder_path}")
        return None
    
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=2000, chunk_overlap=200)
    chunks = text_splitter.split_text(all_text)
    
    embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")
    vector_store = FAISS.from_texts(chunks, embeddings)
    return vector_store

def create_and_save_vector_dbs():
    script_dir = os.path.dirname(os.path.realpath(__file__))
    vector_dbs_dir = os.path.join(script_dir, "..", "Vector DBs")
    os.makedirs(vector_dbs_dir, exist_ok=True)

    vector_stores = {
        "star_class_hotels": create_vector_db("Combined_Resourses", "Places_to_stay", "combined_star_class_hotels.txt"),
        "boutique_villas": create_vector_db("Combined_Resourses", "Places_to_stay", "combined_boutique_villas.txt"),
        "bungalows": create_vector_db("Combined_Resourses", "Places_to_stay", "combined_bungalows.txt"),
        "camping_sites": create_vector_db("Combined_Resourses", "Places_to_stay", "combined_camping_sites.txt"),
        "home_stays": create_vector_db("Combined_Resourses", "Places_to_stay", "combined_home_stays.txt"),
        "normal_hotels": create_vector_db("Combined_Resourses", "Places_to_stay", "combined_normal_hotels.txt"),
        "tourism_resorts": create_vector_db("Combined_Resourses", "Places_to_stay", "combined_sri_lanka_tourism_resorts.txt"),
        "tourist_shops": create_vector_db("Combined_Resourses", "Shops", "combined_tourist_shops.txt"),
        "agents": create_vector_db_from_folder("Combined_Resourses", "Agents"),
        "places_to_stay": create_vector_db_from_folder("Combined_Resourses", "Places_to_stay"),
        "transport": create_vector_db_from_folder("Transport"),
        "attractions": create_vector_db_from_folder("Attractions"),
        "default": create_vector_db_from_folder("scraped_texts")
    }

    for name, vector_store in vector_stores.items():
        if vector_store:
            save_path = os.path.join(vector_dbs_dir, f"{name}_vector_store")
            vector_store.save_local(save_path)
            print(f"Vector store '{name}' created and saved successfully in Vector DBs folder")
        else:
            print(f"Failed to create vector store for '{name}'")

if __name__ == "__main__":
    create_and_save_vector_dbs()