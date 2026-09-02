import json
import logging

# ==========================================
# MASTER CONFIGURATION METRICS (STRICT NAP)
# ==========================================
NAP_DATA = {
    "business_name": "Abogados Lama Estudio Jurídico",
    "street_address": "Av. Luis Thayer Ojeda 0191, Oficina 1403",
    "locality": "Providencia",
    "region": "Región Metropolitana",
    "country": "Chile",
    "formatted_address": "Av. Luis Thayer Ojeda 0191, Oficina 1403, Providencia, Región Metropolitana, Chile",
    "phone": "+56944814363",
    "website": "https://abogadoslama.cl",
    "description": "Estudio jurídico boutique en Sanhattan, Santiago. Especialistas en Ley Karin, Compliance Penal, Bienes Raíces y Litigios."
}

DIRECTORIES = [
    {"name": "Amarillas", "url": "https://www.amarillas.cl/registro"},
    {"name": "Yelp Chile", "url": "https://biz.yelp.cl/signup_business/new"},
    {"name": "Mercantil", "url": "https://www.mercantil.com/registro"},
    {"name": "Axesor", "url": "https://www.axesor.cl/registro-empresa"},
    {"name": "Genealogía de Estudios", "url": "https://www.genealogiadeestudios.cl/add"}
]

def generate_citation_payloads():
    """Generates precise JSON payloads for programmatic directory submission."""
    logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')
    logging.info("Initializing Citation Payload Generator for Abogados Lama...\n")
    
    payloads = {}
    
    for directory in DIRECTORIES:
        # Generate the structured payload matching exact NAP requirements
        payload = {
            "target_directory": directory["name"],
            "endpoint": directory["url"],
            "payload": {
                "company_name": NAP_DATA["business_name"],
                "address": NAP_DATA["formatted_address"],
                "telephone": NAP_DATA["phone"],
                "url": NAP_DATA["website"],
                "category": "Legal Services / Abogados",
                "short_desc": NAP_DATA["description"]
            }
        }
        payloads[directory["name"]] = payload
        logging.info(f"Generated strict NAP payload for: {directory['name']}")
    
    print("\n--- FINAL AUTOMATION PAYLOADS ---")
    print(json.dumps(payloads, indent=2, ensure_ascii=False))
    return payloads

if __name__ == "__main__":
    generate_citation_payloads()
