public class BoxFolderItemsResponse {

	public class Order {
		public String by_Z {get;set;} // in json: by
		public String direction {get;set;} 

		public Order(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'by') {
							by_Z = parser.getText();
						} else if (text == 'direction') {
							direction = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Order consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class FileVersion {
		public String type {get;set;} 
		public String id {get;set;} 
		public String sha1 {get;set;} 

		public FileVersion(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'type') {
							type = parser.getText();
						} else if (text == 'id') {
							id = parser.getText();
						} else if (text == 'sha1') {
							sha1 = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'FileVersion consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class BoxItem {
		public String type {get;set;} 
		public String id {get;set;} 
		public String sequence_id {get;set;} 
		public String etag {get;set;} 
		public String name {get;set;} 
		public FileVersion file_version {get;set;} 
		public String sha1 {get;set;} 
		public String url {get;set;} 

		public BoxItem(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'type') {
							type = parser.getText();
						} else if (text == 'id') {
							id = parser.getText();
						} else if (text == 'sequence_id') {
							sequence_id = parser.getText();
						} else if (text == 'etag') {
							etag = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'file_version') {
							file_version = new FileVersion(parser);
						} else if (text == 'sha1') {
							sha1 = parser.getText();
						} else if (text == 'url') {
							url = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'BoxItem consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Integer total_count {get;set;} 
	public List<BoxItem> entries {get;set;} 
	public Integer offset {get;set;} 
	public Integer limit_Z {get;set;} // in json: limit
	public List<Order> order {get;set;} 

	public BoxFolderItemsResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'total_count') {
						total_count = parser.getIntegerValue();
					} else if (text == 'entries') {
						entries = arrayOfEntries(parser);
					} else if (text == 'offset') {
						offset = parser.getIntegerValue();
					} else if (text == 'limit') {
						limit_Z = parser.getIntegerValue();
					} else if (text == 'order') {
						order = arrayOfOrder(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'BoxFolderItemsResponse consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static BoxFolderItemsResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new BoxFolderItemsResponse(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	





    private static List<BoxItem> arrayOfEntries(System.JSONParser p) {
        List<BoxItem> res = new List<BoxItem>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new BoxItem(p));
        }
        return res;
    }




    private static List<Order> arrayOfOrder(System.JSONParser p) {
        List<Order> res = new List<Order>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Order(p));
        }
        return res;
    }




}