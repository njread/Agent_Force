public class BoxMetadataExtractionRequest {

	public class MetadataTemplate {
		public String template_key;
		public String type;
		public String scope;
	}

	public List<Item> items;
	public MetadataTemplate metadata_template;

	public class Item {
		public String id;
		public String type;
	}

	
	public static BoxMetadataExtractionRequest parse(String json) {
		return (BoxMetadataExtractionRequest) System.JSON.deserialize(json, BoxMetadataExtractionRequest.class);
	}
}