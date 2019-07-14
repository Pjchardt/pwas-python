using UnityEngine;
using Firebase;
using Firebase.Database;
using Firebase.Unity.Editor;
using System.Collections.Generic;
using System.IO;

public class FirebaseTesting : MonoBehaviour
{
    public static FirebaseTesting Instance;

    DatabaseReference mDatabaseRef;

    private void Awake()
    {
        Instance = this;
    }

    void Start()
    {
        // Set up the Editor before calling into the realtime database.
        string s = LoadFirebaseURL();
        FirebaseApp.DefaultInstance.SetEditorDatabaseUrl(s);

        // Get the root reference location of the database.
        mDatabaseRef = FirebaseDatabase.DefaultInstance.RootReference;
    }

    public void UpdateTestValue(float f)
    {
        Debug.Log("Slider value: " + f.ToString());
        Dictionary<string, object> d = new Dictionary<string, object>();
        d.Add("strength_2", f);
        mDatabaseRef.Child("pwas").SetValueAsync(d);
    }

    public string LoadFirebaseURL()
    {
        string path = "Assets/Resources/firebase_url.txt";

        //Read the text from directly from the test.txt file
        StreamReader reader = new StreamReader(path);
        string s = reader.ReadToEnd();
        reader.Close();
        return s;
    }

    //Testing
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.R))
        {
            Dictionary<string, object> d = new Dictionary<string, object>();
            d.Add("r", 1);
            d.Add("g", 0);
            d.Add("b", 0);
            mDatabaseRef.Child("users").Child("0").SetValueAsync(d);
        }

        if (Input.GetKeyDown(KeyCode.G))
        {
            Dictionary<string, object> d = new Dictionary<string, object>();
            d.Add("r", 0);
            d.Add("g", 1);
            d.Add("b", 0);
            mDatabaseRef.Child("users").Child("0").SetValueAsync(d);
        }
    }
}
