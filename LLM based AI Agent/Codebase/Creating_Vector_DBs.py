import os
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import FAISS
from langchain_huggingface import HuggingFaceEmbeddings
from langchain.schema import Document

def create_vector_dbs():
    script_dir = os.path.dirname(os.path.realpath(__file__))
    rag_documents_dir = os.path.join(script_dir, "..", "RAG_Documents")
    vector_dbs_dir = os.path.join(script_dir, "..", "Vector DBs")
    
    # Create the Vector DBs directory if it doesn't exist
    os.makedirs(vector_dbs_dir, exist_ok=True)
    
    embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=2000, chunk_overlap=200)

    def process_file(file_path):
        try:
            with open(file_path, "r", encoding="utf-8") as file:
                text = file.read()
                return Document(page_content=text, metadata={"source": os.path.basename(file_path)})
        except Exception as e:
            print(f"Error reading file {file_path}: {e}")
            return None

    def create_and_save_vector_store(documents, name):
        chunks = text_splitter.split_documents(documents)
        vector_store = FAISS.from_documents(chunks, embeddings)
        vector_store.save_local(os.path.join(vector_dbs_dir, f"{name}_vector_store"))
        print(f"Vector store '{name}' created and saved successfully in Vector DBs folder")

    # 1. Create vector store for scraped_texts
    scraped_texts_dir = os.path.join(rag_documents_dir, "scraped_texts")
    scraped_texts = [process_file(os.path.join(scraped_texts_dir, f)) for f in os.listdir(scraped_texts_dir) if os.path.isfile(os.path.join(scraped_texts_dir, f))]
    create_and_save_vector_store([doc for doc in scraped_texts if doc], "scraped_texts")

    # 2. Create vector store for Attractions
    attractions_dir = os.path.join(rag_documents_dir, "Attractions")
    attractions = [process_file(os.path.join(attractions_dir, f)) for f in os.listdir(attractions_dir) if os.path.isfile(os.path.join(attractions_dir, f))]
    create_and_save_vector_store([doc for doc in attractions if doc], "attractions")

    # 3. Create vector stores for combined resources
    combined_resources_dir = os.path.join(rag_documents_dir, "Combined_Resourses")
    
    # Create vector store for combined_tour_guides and combined_travel_agents
    tour_guides_and_agents_files = ["combined_tour_guides", "combined_travel_agents"]
    tour_guides_and_agents_docs = []
    for filename in tour_guides_and_agents_files:
        file_path = os.path.join(combined_resources_dir, f"{filename}.txt")
        doc = process_file(file_path)
        if doc:
            tour_guides_and_agents_docs.append(doc)
    create_and_save_vector_store(tour_guides_and_agents_docs, "Tour_guides_and_agents")

    # Create vector store for combined_tourist_shops
    tourist_shops_file = os.path.join(combined_resources_dir, "combined_tourist_shops.txt")
    tourist_shops_doc = process_file(tourist_shops_file)
    if tourist_shops_doc:
        create_and_save_vector_store([tourist_shops_doc], "Tourist_shops")

    # 4. Create vector stores for Places_to_stay
    places_to_stay_dir = os.path.join(combined_resources_dir, "Places_to_stay")
    for filename in os.listdir(places_to_stay_dir):
        file_path = os.path.join(places_to_stay_dir, filename)
        if os.path.isfile(file_path):
            doc = process_file(file_path)
            if doc:
                create_and_save_vector_store([doc], f"places_to_stay_{os.path.splitext(filename)[0]}")

if __name__ == "__main__":
    create_vector_dbs()