SELECT c3.sku, c2.value
FROM catalog_category_product c1
INNER JOIN catalog_category_entity_varchar c2 ON (c1.category_id = c2.entity_id)
INNER JOIN catalog_product_entity c3 ON (c1.product_id = c3.entity_id)
WHERE c2.attribute_id = (SELECT attribute_id FROM eav_attribute WHERE attribute_code = 'name' AND entity_type_id = 3)
AND c3.sku = 'WMF_0617706790'