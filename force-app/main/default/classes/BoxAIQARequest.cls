public class BoxAIQARequest {

	public class Config {
		public Boolean is_streamed;
	}

	public class Item {
		public String id;
		public String type;
		public String content;
	}

	public String mode;
	public String prompt;
	public List<Item> items;
	public Config config;

	
	public static BoxAIQARequest parse(String json) {
		return (BoxAIQARequest) System.JSON.deserialize(json, BoxAIQARequest.class);
	}
}