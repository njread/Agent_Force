public class BoxAIQAResponse {

	public String answer;
	public String created_at;
	public String completion_reason;

	
	public static BoxAIQAResponse parse(String json) {
		return (BoxAIQAResponse) System.JSON.deserialize(json, BoxAIQAResponse.class);
	}
}