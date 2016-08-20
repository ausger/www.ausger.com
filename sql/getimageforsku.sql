SELECT a.sku, b.value, c.position
FROM `catalog_product_entity` AS a
LEFT JOIN `catalog_product_entity_media_gallery` AS b ON a.entity_id = b.entity_id
INNER JOIN `catalog_product_entity_media_gallery_value` AS c ON c.value_id = b.value_id
WHERE a.sku = 98044057168