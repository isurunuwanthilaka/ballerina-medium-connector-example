import ballerina/config;
import ballerina/io;
import isurun/medium;

// Authentication
medium:Configuration mediumConfig = {
    accessToken: config:getAsString("ACCESS_TOKEN")
};

medium:Client mediumClient = new (mediumConfig);

public function main() {
    //1.User
    //get the root user info
    var result1 = mediumClient->myInfo();
    if (result1 is medium:User) {
        io:println("My user name : ", result1.username);
    } else {
        io:println("Error: ", result1);
    }

    //2.Publications
    //get root user's own publication list
    var result2 = mediumClient->getMyPublications();
    if (result2 is medium:Publication[]) {
        io:println("My publication->first item name : ", result2[0].name);    //here only showing first publication, retrive as you want.
    } else {
        io:println("Error: ", result2);
    }

    //get user publication list when userID is known
    var result3 = mediumClient->getUserPublications("19ee90b2494c92e1bcd33a6654c27ba234e934ac2d9d9af8394231ee7bc26affa");
    if (result3 is medium:Publication[]) {
        io:println("User publication->first item name : ", result3[0].name);    //here only showing first publication, retrive as you want.
    } else {
        io:println("Error: ", result2);
    }

    //get contributor list when publicationID is known
    var result4 = mediumClient->getContributors("336d898217ee");
    if (result4 is medium:Contributor[]) {
        io:println("First contributor's role : ", result4[0].role);    //here only showing first publication, retrive as you want.
    } else {
        io:println("Error: ", result4);
    }

    //3.Posts

    //Publish,draft or unlist a post on medium platform

    //create a post
    medium:Post post = new ();
    post.setTitle("Ballerina Medium Connector Alert!");
    post.setPublishStatus("draft");
    post.setContent("<h1>Ballerina Medium Connector</h1><p>You’ll never walk alone.</p>");
    post.setLicense("all-rights-reserved");
    post.setNotifyFollowers(false);
    post.setContentFormat("html");
    post.setCanonicalUrl("https://medium.com/");
    post.setTags(["ballerina", "medium", "integration"]);

    //publish the post
    var result5 = mediumClient->createPost(post, "19ee90b2494c92e1bcd33a6654c27ba234e934ac2d9d9af8394231ee7bc26affa");

    if (result5 is medium:PostResponse) {
        io:println("Post Url : ", result5.url);
    } else {
        io:println("Error: ", result5);
    }

    //publish post to publication
    // var result6 = mediumClient->createPostToPublication(post,"#publicationID#");

    // if (result6 is medium:PostResponse) {
    //      io:println("Publication Post Url : ",result6.url);
    // } else {
    //     io:println("Error: ", result6);
    // }

    //4.Image
    //create image
    medium:Image image = new ();
    image.setFormat("jpg");//jpg,png,gif,tiff
    image.setImageLocation("C:/Users/isurun/Downloads/download.jpg");

    //publish image
    var result7 = mediumClient->createImage(image);

    if (result7 is medium:ImageResponse) {
        io:println("Image Url : ", result7.url);
    } else {
        io:println("Error: ", result7);
    }

    //you can push your local images to medium first, then get that url
    //and place in the <img> tag src=url so that you can use that image 
    //in the post

}
