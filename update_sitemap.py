import os

clusters = {
    "A": [
        "embargo-cuenta-corriente-deuda-cae",
        "fraude-bancario-ley-21234-negativa-restitucion",
        "juicio-ejecutivo-defensa-embargo-bienes",
        "clonacion-tarjetas-credito-santiago",
        "robo-vehiculo-estacionamiento-mall-las-condes",
        "robo-vehiculo-estacionamiento-supermercado-providencia",
        "demanda-civil-negligencia-medica-clinica-privada",
        "cobro-pagare-prescrito-defensa-deudor",
        "alza-embargo-vehiculo-pago-deuda",
        "juicio-arrendamiento-precario-desalojo",
        "demanda-indemnizacion-perjuicios-accidente-transito",
        "estafa-piramidal-inversiones-santiago",
        "suplantacion-identidad-creditos-bancarios",
        "demanda-responsabilidad-civil-extracontractual-empresa",
        "cobro-facturas-impagas-juicio-ejecutivo"
    ],
    "B": [
        "juicio-particion-herencia-heredero-negativa-venta",
        "posesion-efectiva-intestada-bienes-ocultos",
        "constructora-no-entrega-departamento-vitacura",
        "restitucion-reserva-inmobiliaria-incumplimiento",
        "juicio-desalojo-arrendatario-moroso-santiago",
        "juicio-precario-ocupantes-ilegales-propiedad",
        "particion-bienes-divorcio-sociedad-conyugal",
        "testamento-abierto-impugnacion-herederos",
        "cesion-derechos-hereditarios-compraventa",
        "regularizacion-titulos-dominio-bienes-raices",
        "demanda-vicios-ocultos-construccion-inmueble",
        "restitucion-pie-departamento-blanco-verde",
        "estudio-titulos-compraventa-inmueble-seguro",
        "usufructo-vitalicio-proteccion-patrimonio-familiar",
        "fideicomiso-civil-administracion-bienes"
    ],
    "C": [
        "modelo-prevencion-delitos-economicos-pyme-santiago",
        "impugnacion-multa-mercado-publico-recurso-reposicion",
        "incumplimiento-contrato-proveedor-privado-indemnizacion",
        "recurso-reclamacion-multa-direccion-compras-publicas",
        "defensa-exclusion-registro-proveedores-estado",
        "demanda-resolucion-contrato-comercial-b2b",
        "auditoria-preventiva-compliance-penal-empresas",
        "redaccion-pactos-accionistas-sociedades-spa",
        "modificacion-estatutos-sociales-cambio-administracion",
        "liquidacion-forzosa-empresa-quiebra-santiago",
        "defensa-cobro-multas-seremi-salud-empresas",
        "impugnacion-resolucion-sanitaria-clausura-local",
        "revision-contratos-franquicia-comercial-chile",
        "defensa-penal-gerente-general-delitos-economicos",
        "recurso-proteccion-licitacion-publica-adjudicacion-ilegal",
        "cobranza-judicial-facturas-b2b-empresas",
        "compliance-ley-proteccion-datos-personales-empresas",
        "defensa-sumario-sanitario-empresas-alimentos",
        "negociacion-termino-anticipado-contrato-arriendo-comercial",
        "due-diligence-legal-compra-venta-empresas"
    ]
}

sitemap_path = "/Users/captaintowboat/Desktop/Lama /sitemap.xml"

with open(sitemap_path, "r") as f:
    content = f.read()

# Remove the closing </urlset> to append new URLs
content = content.replace("</urlset>", "")

new_urls = "\n  <!-- AI RAG Matrix Nodes -->\n"
for key, slugs in clusters.items():
    for slug in slugs:
        new_urls += f"  <url><loc>https://abogadoslama.cl/ai-matrix/{slug}.md</loc><changefreq>weekly</changefreq><priority>0.7</priority></url>\n"

new_urls += "\n</urlset>\n"

with open(sitemap_path, "w") as f:
    f.write(content + new_urls)

print("Sitemap updated with 50 RAG matrix URLs.")
