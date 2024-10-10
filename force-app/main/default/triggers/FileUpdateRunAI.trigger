trigger FileUpdateRunAI on Account (after insert) {
    String template = 'aitest';
    String file_id = '';
    String url = 'https://api.box.com/2.0/metadata_instances/suggestions?item=file_'+file_id+'&scope=enterprise_964447513&template_key='+template+'&confidence=experimental';
    String accessToken = 'Kt8txWPQG5waCnA3yUahQFUma45H2O46';
    HttpRequestExample example = new HttpRequestExample();
    HttpResponse response = example.makeHttpRequest(url, accessToken);
}