SELECT 'geologicunitview.' || row_number() OVER (ORDER BY polys.mapunitpolys_id) AS id, polys.mapunitpolys_id AS featureuri, dmu.name, dmu.fullname, dmu.label, 'urn:ogc:def:nil:OGC:missing'::character varying AS parenturi, dmu.description, dmu.areafillrgb AS symbol, dmu.descriptionofmapunits_id AS specificationuri, 'urn:cgi:classifier:CGI:GeologicUnitType:200811:lithostratigraphic_unit'::character varying AS geologicunittype, preferredage.agedisplay AS geologichistory, 
        CASE preferredage.agedisplayurn IS NULL
            WHEN true THEN preferredage.youngerurn
            ELSE preferredage.agedisplayurn
        END AS representativeageuri, preferredage.youngerurn AS youngerageuri, preferredage.olderurn AS olderageuri, dmu.hierarchykey AS rank, dmuext.lithology_summary AS lithology, ccl.cgiurn AS representativelithologyuri, 'urn:ogc:def:nil:OGC:missing'::character varying AS observationmethod, polys.datasourceid AS sourceuri, polys.datasourceid AS metadatauri, polys.shape
   FROM ncgmp_mapunitpolys polys
   JOIN ncgmp_descriptionofmapunits dmu ON polys.mapunit::text = dmu.mapunit::text
   JOIN ncgmp_datasources ds ON polys.datasourceid::text = ds.datasources_id::text
   JOIN usgin.geologicevent preferredage ON dmu.descriptionofmapunits_id::text = preferredage.preferredage_dmu_id::text
   LEFT JOIN ncgmp_ex_dmuextension dmuext ON dmu.mapunit::text = dmuext.mapunit::text
   LEFT JOIN usgin.controlledconceptlookup ccl ON dmuext.representative_lithology = ccl.lookupterm::text;
