//  Created by Cameron Trotter on 24/03/2016.
//  Copyright © 2016 Cameron Trotter. All rights reserved.
//
// This file controls the Notes list

import UIKit

class TableViewController: UITableViewController, NoteViewDelegate {
    
    @IBOutlet var open: UIBarButtonItem!
    
    //  Keys = "title", "body"
    var arrNotes = [[String:String]]()
    var selectedIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        if let newNotes = NSUserDefaults.standardUserDefaults().arrayForKey("notes") as? [[String:String]] {
            arrNotes = newNotes
        }
        open.target = self.revealViewController()
        open.action = Selector("revealToggle:")
        self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // Get the number of notes to show
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return arrNotes.count
    }
    // Names the cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
                as UITableViewCell
            cell.textLabel!.text = arrNotes[indexPath.row]["title"]
            return cell
    }
    // What to do when a note is selected
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            self.selectedIndex = indexPath.row
            performSegueWithIdentifier("showEditorSegue", sender: nil)
    }
    // Loads data needed for the segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender:
        AnyObject?) {
            let notesEditorVC = segue.destinationViewController as!
            NotesViewController
            notesEditorVC.navigationItem.title =
                arrNotes[self.selectedIndex]["title"]
            notesEditorVC.strBodyText =
                arrNotes[self.selectedIndex]["body"]
            notesEditorVC.delegate = self
    }
    // Deleting notes
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            tableView.beginUpdates()
            NSUserDefaults.standardUserDefaults().removeObjectForKey("title")
            arrNotes.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.endUpdates()
            saveNotesArray()
        }
    }
    // Function called when Plus button is clicked
    @IBAction func newNote() {
        let newDict = ["title" : "",
            "body" : ""]
        arrNotes.insert(newDict, atIndex: 0)
        self.selectedIndex = 0
        self.tableView.reloadData()
        saveNotesArray()
        performSegueWithIdentifier("showEditorSegue", sender: nil)
    }
    // Updates the note's title as typed
    func didUpdateNoteWithTitle(newTitle: String, andBody newBody:
        String) {
            self.arrNotes[self.selectedIndex]["title"] = newTitle
            self.arrNotes[self.selectedIndex]["body"] = newBody
            self.tableView.reloadData()
            saveNotesArray()
    }
    // Call to save the Notes Array as needed
    func saveNotesArray() {
        NSUserDefaults.standardUserDefaults().setObject(arrNotes,
            forKey: "notes")
        NSUserDefaults.standardUserDefaults().synchronize()
    }    
}

