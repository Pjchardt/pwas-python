# pi_pyrebase_processing_template

Template project for connecting to Firebase and sending database data to Processing for visualization

Sister project to Unity project that updates firebase with values pi uses for visualization in processing. 

Example simple Unity script setting data read by python code:

```C#
using UnityEngine;
using Firebase;
using Firebase.Database;
using Firebase.Unity.Editor;

public class FirebaseTesting : MonoBehaviour
{
    DatabaseReference mDatabaseRef;

    void Start()
    {
        // Set up the Editor before calling into the realtime database.
        FirebaseApp.DefaultInstance.SetEditorDatabaseUrl("https://your_firebase_url.firebaseio.com/");

        // Get the root reference location of the database.
        mDatabaseRef = FirebaseDatabase.DefaultInstance.RootReference;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            mDatabaseRef.Child("users").Child("0").SetValueAsync(Time.timeSinceLevelLoad);
        }
    }
}
```
