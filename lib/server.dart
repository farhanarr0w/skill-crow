import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

const MONGO_URL =
    "mongodb+srv://admin:abc123ef@cluster0.hq1ekox.mongodb.net/SkillCrow?retryWrites=true&w=majority";

const CHAT_COLLECTION = 'Chat';
var db;

class Server {
  static var cursor;

  static List<Map<String, dynamic>>? FreelancersList;
  static List<Map<String, dynamic>>? ClientsList;
  static List<Map<String, dynamic>>? adminlist;
  static List<Map<String, dynamic>>? chatlist;

  static List<Map<String, dynamic>>? JobPostsList;
  static List<Map<String, dynamic>>? JobCategoriesList;
  static List<Map<String, dynamic>>? ProposalsList;
  static List<Map<String, dynamic>>? WorkHistoryList;
  static List<Map<String, dynamic>>? ContractsList;
  static List<Map<String, dynamic>>? JobsList;

  static List<Map<String, dynamic>>? SkillsList;

  static List<Map<String, dynamic>>? JobCategoriesListsearch;

  static var FreelancerCollection;
  static var ClientCollection;
  static var AdminCollection;
  static var chatcollection;

  static var JobPostCollection;
  static var JobCategoryCollection;
  static var JobCategoryCollectionsearch;
  static var ProposalsCollection;
  static var WorkHistoryCollection;
  static var ContractsCollection;
  static var SkillsCollection;

  static start() async {
    print("App Start");
    db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);

    FreelancerCollection = db.collection("Freelancer");
    ClientCollection = db.collection("Client");
    JobPostCollection = db.collection("JobPosts");
    JobCategoryCollection = db.collection("JobCategories");
    ProposalsCollection = db.collection("Proposals");
    WorkHistoryCollection = db.collection("WorkHistory");
    ContractsCollection = db.collection("Contracts");
    SkillsCollection = db.collection("Skills");
    AdminCollection = db.collection("admin");
    chatcollection = db.collection("Chat");

    JobCategoryCollectionsearch = db.collection("JobCategories");

    await refresh();
  }

  static refresh() async {
    final stopwatch = Stopwatch()..start();

    print("Fetching Start!");
    print('');
    cursor = await FreelancerCollection.find();
    FreelancersList = await cursor.toList();

    cursor = await ClientCollection.find();
    ClientsList = await cursor.toList();

    cursor = await JobPostCollection.find();
    JobPostsList = await cursor.toList();

    cursor = await AdminCollection.find();
    adminlist = await cursor.toList();

    cursor = await chatcollection.find();
    chatlist = await cursor.toList();

    cursor = await JobCategoryCollection.find();
    JobCategoriesList = await cursor.toList();

    cursor = await ProposalsCollection.find();
    ProposalsList = await cursor.toList();

    cursor = await WorkHistoryCollection.find();
    WorkHistoryList = await cursor.toList();

    cursor = await ContractsCollection.find();
    ContractsList = await cursor.toList();

    cursor = await JobPostCollection.find();
    JobsList = await cursor.toList();

    cursor = await SkillsCollection.find();
    SkillsList = await cursor.toList();

    cursor = await JobCategoryCollectionsearch.find();
    JobCategoriesListsearch = await cursor.toList();

    print("Fetching Completed!");

    stopwatch.stop();
    print('Time taken: ${stopwatch.elapsed.inSeconds} seconds');
  }
}

class CrudFunction {
  static var cl_editingJob;

  var deepEq = DeepCollectionEquality();
  static var recommendedFreelancers;

  static var freelancer;
  static var thatJob;
  static var thatProposal;

  static var fr_thatClient;
  static var fr_thatProposal;
  static var fr_thatJob;
  static var cl_thatFreelancer;
  static var cl_thatProposal;
  static var cl_thatJob;

  static var UserFind;
  static var ClientFind;
  static var AdminFind;
  static var chatfind;

  static var jobContract;
  static List<String> displaySkills = [];
  static var AllSkills = [];

  static List<Map<String, dynamic>> tempJobShowFr = [];
  static List<Map<String, dynamic>> tempJobShowsFrsearch = [];

  static List<Map<String, dynamic>>? filteredJobsFr;
  static List<Map<String, dynamic>>? filteredJobFrsearch;

  static Map<String, dynamic>? currentJob;

  static List<Map<String, dynamic>> tempJobShowCl = [];
  static List<Map<String, dynamic>>? filteredJobsCl;

  static List<Map<String, dynamic>> tempProposals = [];
  static List<Map<String, dynamic>>? filteredProposals;

  static List<Map<String, dynamic>> tempFRProposals = [];
  static List<Map<String, dynamic>>? filteredFRProposals;


  static List<Map<String, dynamic>> tempFRchats = [];
  static List<Map<String, dynamic>>? filteredFRchats;

  static List<Map<String, dynamic>> tempFRInvites = [];
  static List<Map<String, dynamic>>? filteredFRInvites;

  static List<Map<String, dynamic>> tempFRContracts = [];
  static List<Map<String, dynamic>>? filteredFRContracts;

  static List<Map<String, dynamic>> tempFRJobs = [];
  static List<Map<String, dynamic>>? filteredFRJobs;

  static List<Map<String, dynamic>> tempCLContracts = [];
  static List<Map<String, dynamic>>? filteredCLContracts;

  static List<Map<String, dynamic>> tempFRContractswithstatus = [];
  static List<Map<String, dynamic>>? filteredFRContractswithstatus;

  static var JobInfoForInvite;

  static var InviteUserView;

// JSS = [Jobs Completed / (Total Jobs - Jobs In Progress)] * 100

  static filterInvites(String freelancerUsername) {
    print("Entered Invite Filtering");

    for (var job in Server.JobPostsList!) {
      if (job['Invites'] == freelancerUsername) {
        tempFRInvites.add(job);
      }
    }
    filteredFRInvites = tempFRInvites;
    tempFRInvites = [];

    print("Proposals Invite Complete");
  }

  static sendInvite(ObjectId jobID, String freelancerUsername) async {
    print('sending Invite');

    ((Server.FreelancersList!.firstWhereOrNull(
            (fr) => fr['UserName'] == freelancerUsername))!['Invites'])
        .add(jobID);

    var frInv = (Server.FreelancersList!.firstWhereOrNull(
        (fr) => fr['UserName'] == freelancerUsername))!['Invites'];

    (Server.JobPostsList!
        .firstWhereOrNull((job) => job['_id'] == jobID))!['NoOfInvites'] += 1;

    int noOfInvites = (Server.JobPostsList!
        .firstWhereOrNull((job) => job['_id'] == jobID))!['NoOfInvites'];

    (Server.JobPostsList!
            .firstWhereOrNull((job) => job['_id'] == jobID))!['Invites'] =
        freelancerUsername;

    await Server.JobPostCollection.update(
        where.eq("_id", jobID),
        modify
            .set("NoOfInvites", noOfInvites)
            .set("Invites", freelancerUsername));

    await Server.FreelancerCollection.update(
        where.eq("UserName", freelancerUsername), modify.set("Invites", frInv));

    print('invite sent');
    Server.refresh();
  }

  static Future<bool> Loginadmin(String username, String pass) async {
    AdminFind = Server.adminlist
        ?.firstWhereOrNull((user) => user['UserName'] == username);

    if (AdminFind != null && AdminFind['Password'] == pass) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  static approveRefund(ObjectId contractID) async {
    print('Approving Refund');
    (Server.ContractsList!.firstWhereOrNull(
            (contract) => contract['_id'] == contractID))!['ContractStatus'] =
        "refundApproved";

    (Server.ContractsList!.firstWhereOrNull(
        (contract) => contract['_id'] == contractID))!['EscrowAmount'] = 0;

    await Server.ContractsCollection.update(where.eq("_id", contractID),
        modify.set("ContractStatus", "refundApproved"));

    await Server.ContractsCollection.update(
        where.eq("_id", contractID), modify.set("EscrowAmount", 0));
    print('Refund Approved');
    Server.refresh();
  }

  static declineRefund(ObjectId contractID) async {
    print('Declining Refund');
    (Server.ContractsList!.firstWhereOrNull(
            (contract) => contract['_id'] == contractID))!['ContractStatus'] =
        "refundDeclined";

    await Server.ContractsCollection.update(where.eq("_id", contractID),
        modify.set("ContractStatus", "refundDeclined"));

    print('Refund Declined');
    Server.refresh();
  }

  static requestRefund(ObjectId contractID) async {
    print('Requesting Refund');
    (Server.ContractsList!.firstWhereOrNull(
            (contract) => contract['_id'] == contractID))!['ContractStatus'] =
        "refundRequested";

    await Server.ContractsCollection.update(where.eq("_id", contractID),
        modify.set("ContractStatus", "refundRequested"));
    print('Refund Requested');
    Server.refresh();
  }

  static approvePayment(String freelancerUsername, String clientUsername,
      ObjectId contractID, int escrowAmount) async {
    /**
 Freelancer Database:
 - Total Earnings

  Client Database:
 - TotalSpent

 Contracts Database:
 - AmountPaid
 - EscrowAmount
 */
    print("Approving Payment");
    int tSpent;
    int tEarn;
    int amntPaid;

    (Server.ContractsList!.firstWhereOrNull(
            (contract) => contract['_id'] == contractID))!['AmountPaid'] +=
        escrowAmount;

    (Server.ContractsList!.firstWhereOrNull(
        (contract) => contract['_id'] == contractID))!['EscrowAmount'] = 0;

    amntPaid = (Server.ContractsList!.firstWhereOrNull(
        (contract) => contract['_id'] == contractID))!['AmountPaid'];

    (Server.ClientsList!.firstWhereOrNull(
            (client) => client['UserName'] == clientUsername))!['TotalSpent'] +=
        escrowAmount;

    tSpent = (Server.ClientsList!.firstWhereOrNull(
        (client) => client['UserName'] == clientUsername))!['TotalSpent'];

    (Server.FreelancersList!.firstWhereOrNull((freelancer) =>
            freelancer['UserName'] == freelancerUsername))!['TotalEarnings'] +=
        escrowAmount;

    tEarn = (Server.FreelancersList!.firstWhereOrNull((freelancer) =>
        freelancer['UserName'] == freelancerUsername))!['TotalEarnings'];

    await Server.ContractsCollection.update(where.eq("_id", contractID),
        modify.set("AmountPaid", amntPaid).set("EscrowAmount", 0));

    await Server.ClientCollection.update(
        where.eq("UserName", clientUsername), modify.set("TotalSpent", tSpent));

    await Server.FreelancerCollection.update(
        where.eq("UserName", freelancerUsername),
        modify.set("TotalEarnings", tEarn));
    print('Payment Approved');
    Server.refresh();
  }

  static submitWork(
      ObjectId contractID, List<Map<String, dynamic>> SubmittedFiles) async {
    print('Submitting Work');
    await Server.ContractsCollection.update(
        where.eq('_id', contractID),
        modify
            .set('SubmissionStatus', 'submitted')
            .set('SubmittedFiles', SubmittedFiles));

    (Server.ContractsList!.firstWhereOrNull(
            (contract) => contract['_id'] == contractID))!['SubmissionStatus'] =
        'submitted';

    print((Server.ContractsList!.firstWhereOrNull(
        (contract) => contract['_id'] == contractID))!['SubmissionStatus']);

    print('Work Submitted');
    Server.refresh();
  }

  static filterClientContracts(String clientUsername) {
    print("Entered Contracts Filtering");
    for (var contract in Server.ContractsList!) {
      if (contract['ClientUsername'] == clientUsername) {
        tempCLContracts.add(contract);
      }
    }
    filteredCLContracts = tempCLContracts;
    tempCLContracts = [];
    print("Contracts Filtering Complete");
  }

  static filterContracts(String freelancerUsername) {
    print("Entered Contracts Filtering");
    for (var contract in Server.ContractsList!) {
      if (contract['FreelancerUsername'] == freelancerUsername) {
        tempFRContracts.add(contract);
      }
    }
    filteredFRContracts = tempFRContracts;
    tempFRContracts = [];
    print("Contracts Filtering Complete");
  }

  static filterJobs(String freelancerUsername) {
    print("Entered Jobs Filtering");
    for (var job in Server.JobsList!) {
      for (var savedjobs in CrudFunction.UserFind['SavedJobs']) {
        if (savedjobs['jobid'] == job['_id'].toString()) {
          tempFRJobs.add(job);
        }
      }
    }
    filteredFRJobs = tempFRJobs;
    tempFRJobs = [];
    print("Jobs Filtering Complete");
  }

  static Future<void> updateclientpass(String UserName, String pass) async {
    print('name ' + pass);
    print('UserName ' + UserName);

    await Server.ClientCollection.update(
        where.eq("UserName", UserName), modify.set("Password", pass));
  }

  static editJob(
      ObjectId JobID,
      String JobTitle,
      String JobDescription,
      String JobCategory,
      int Budget,
      int SeedsRequired,
      var SkillsReq,
      String ExpertiseLevel,
      var PostingDate) async {
    print("Updating Job");
    await Server.JobPostCollection.update(
        where.eq('_id', JobID),
        modify
            .set('JobTitle', JobTitle)
            .set('JobDescription', JobDescription)
            .set('JobCategory', JobCategory)
            .set('Budget', Budget)
            .set('SeedsRequired', SeedsRequired)
            .set('SkillsRequired', SkillsReq)
            .set('ExpertiseLevel', ExpertiseLevel)
            .set('PostingDate', PostingDate));
    Server.refresh();
    print('Job Updated');
  }

  static closeJob(ObjectId JobID) async {
    print('closing Job');
    await Server.JobPostCollection.update(
        where.eq("_id", JobID), modify.set("JobStatus", 'closed'));

    await Server.ProposalsCollection.deleteMany(where.eq('JobID', JobID));

    Server.ProposalsList!.removeWhere((prop) => prop['JobID'] == JobID);

    (Server.JobPostsList!
            .firstWhereOrNull((job) => job['_id'] == JobID))!['JobStatus'] =
        'closed';
    print('Job closed');
    Server.refresh();
  }

  static contractCompleted(ObjectId contractID) async {
    print('Contract Completed');
    (Server.ContractsList!.firstWhereOrNull(
            (contract) => contract['_id'] == contractID))!['ContractStatus'] =
        "completed";

    await Server.ContractsCollection.update(
        where.eq("_id", contractID), modify.set("ContractStatus", "completed"));

    print('Contract Completed');
    Server.refresh();
  }

  static declineContract(ObjectId ContractID, ObjectId PropID) async {
    await Server.ContractsCollection.update(
        where.eq("_id", ContractID), modify.set("ContractStatus", 'declined'));
    (Server.ContractsList!.firstWhereOrNull(
            (contract) => contract['_id'] == ContractID))!['ContractStatus'] =
        'declined';

    await Server.ProposalsCollection.update(where.eq("_id", PropID),
        modify.set("ProposalStatus", 'ContractDeclined'));
    (Server.ProposalsList!.firstWhereOrNull((prop) => prop['_id'] == PropID))![
        'ProposalStatus'] = 'ContractDeclined';

    Server.refresh();
  }

  static acceptInvitedContract(ObjectId ContractID) async {
    await Server.ContractsCollection.update(
        where.eq("_id", ContractID), modify.set("ContractStatus", 'started'));

    (Server.ContractsList!.firstWhereOrNull(
            (contract) => contract['_id'] == ContractID))!['ContractStatus'] =
        'started';

    Server.refresh();
  }

  static acceptContract(ObjectId ContractID, ObjectId PropID) async {
    await Server.ContractsCollection.update(
        where.eq("_id", ContractID), modify.set("ContractStatus", 'started'));

    (Server.ContractsList!.firstWhereOrNull(
            (contract) => contract['_id'] == ContractID))!['ContractStatus'] =
        'started';

    await Server.ProposalsCollection.update(where.eq('_id', PropID),
        modify.set('ProposalStatus', 'ContractStarted'));

    (Server.ProposalsList!.firstWhereOrNull((prop) => prop['_id'] == PropID))![
        'ProposalStatus'] = 'ContractStarted';

    Server.refresh();
  }

  static sendInviteContract(
    ObjectId JobID,
    String ClientUsername,
    String FreelancerUsername,
    int ProjectPrice,
    int EscrowAmount,
    int AmountPaid,
    String ContractDescription,
    String SubmissionStatus,
    String ContractStatus,
    var StartDate,
  ) async {
    print("Sending Contract");

    var newContract = {
      'ProposalID': "Invited Contract",
      'JobID': JobID,
      'ClientUsername': ClientUsername,
      'FreelancerUsername': FreelancerUsername,
      'ProjectPrice': ProjectPrice,
      'EscrowAmount': EscrowAmount,
      'AmountPaid': AmountPaid,
      'ContractDescription': ContractDescription,
      'SubmissionStatus': SubmissionStatus,
      'ContractStatus': ContractStatus,
      'StartDate': StartDate,
    };

    Server.ContractsList!.add(newContract);
    Server.ContractsCollection.insertOne(newContract);

    Server.refresh();
    print("Contract Sent");
  }

  static sendContract(
    ObjectId PropID,
    ObjectId JobID,
    String ClientUsername,
    String FreelancerUsername,
    int ProjectPrice,
    int EscrowAmount,
    int AmountPaid,
    String ContractDescription,
    String SubmissionStatus,
    String ContractStatus,
    var StartDate,
  ) async {
    print("Sending Contract");

    var newContract = {
      'ProposalID': PropID,
      'JobID': JobID,
      'ClientUsername': ClientUsername,
      'FreelancerUsername': FreelancerUsername,
      'ProjectPrice': ProjectPrice,
      'EscrowAmount': EscrowAmount,
      'AmountPaid': AmountPaid,
      'ContractDescription': ContractDescription,
      'SubmissionStatus': SubmissionStatus,
      'ContractStatus': ContractStatus,
      'StartDate': StartDate,
    };

    Server.ContractsList!.add(newContract);
    Server.ContractsCollection.insertOne(newContract);

    await Server.ProposalsCollection.update(
        where.eq("_id", PropID), modify.set("ContractSent", true));

    await Server.JobPostCollection.update(
        where.eq('_id', JobID).eq('Proposals._id', PropID),
        modify.set('Proposals.\$.ContractSent', true));

    Server.refresh();
    print("Contract Sent");
  }

  static updateSeeds(String UserName, int UpdatedSeeds) async {
    print("Seeds updating to Database");
    Server.FreelancerCollection.update(
        where.eq("UserName", UserName), modify.set("Seeds", UpdatedSeeds));
    print("Seeds Updated!!!");
  }

  static viewProposals(ObjectId jobID) {
    print("Entered Proposals Filtering");
    for (var proposal in Server.ProposalsList!) {
      if (proposal['JobID'] == jobID &&
          proposal['ProposalStatus'] != 'declined') {
        tempProposals.add(proposal);
      }
    }
    filteredProposals = tempProposals;
    tempProposals = [];
    print("Proposals Filtering Complete");
  }

  static getProposals(ObjectId jobID) {
    print("Entered Proposals Filtering");
    for (var proposal in Server.ProposalsList!) {
      if (proposal['_id'] == jobID) {
        tempProposals.add(proposal);
      }
    }
    filteredProposals = tempProposals;
    tempProposals = [];
    print("Proposals Filtering Complete");
  }




  static searchJobsByCategory(String category) {
    print("Entered Filtering for: " + category);
    for (var job in Server.JobPostsList!) {
      if (job['JobCategory'] == category && job['JobStatus'] != 'closed') {
        tempJobShowFr.add(job);
      }
    }
    filteredJobsFr = tempJobShowFr;
    tempJobShowFr = [];

    print("Filtering Complete");
  }

  static filterProposals(String freelancerUsername) {
    print("Entered Proposal Filtering");
    for (var proposal in Server.ProposalsList!) {
      if (proposal['FreelancerUsername'] == freelancerUsername &&
          proposal['ProposalStatus'] != 'ContractStarted' &&
          proposal['ProposalStatus'] != 'ContractDeclined') {
        tempFRProposals.add(proposal);
      }
    }
    filteredFRProposals = tempFRProposals;
    tempFRProposals = [];
    print("Proposals Filtering Complete");
  }

  static filterchat(String session) {
    print("Entered chat Filtering");
        chatfind = Server.chatlist?.firstWhereOrNull(
                (chat) => chat['Session'] == session);
    print(chatfind);
    print("Proposals Filtering Complete");
  }

  static searchJobsByCategoryandtitle(String category, String jobTitle) {
    print("Entered Filtering for: $jobTitle");
    String lowercasedJobTitle =
        jobTitle.toLowerCase(); // Convert jobTitle to lowercase
    for (var job in Server.JobPostsList!) {
      String jobTitleInLowerCase = job['JobTitle']
          .toString()
          .toLowerCase(); // Convert job title to lowercase
      if (job['JobCategory'] == category &&
          jobTitleInLowerCase.contains(lowercasedJobTitle)) {
        tempJobShowsFrsearch.add(job);
      }
    }
    filteredJobFrsearch = tempJobShowsFrsearch;
    tempJobShowsFrsearch = [];
    print("Filtering Complete");
  }

  static searchJobsByClient(String ClientUsername) {
    print("Entered Filtering");
    for (var job in Server.JobPostsList!) {
      if (job['ClientUsername'] == ClientUsername) {
        tempJobShowCl.add(job);
      }
    }
    filteredJobsCl = tempJobShowCl;
    tempJobShowCl = [];
    print("Filtering Complete");
  }

  static currentJobUpdater(String jobTitle) {
    currentJob =
        filteredJobsFr!.firstWhereOrNull((job) => job['JobTitle'] == jobTitle);
  }

  static InsertFreelancer(
      String image,
      String username,
      String email,
      String password,
      int phone,
      String firstName,
      String lastName,
      String title,
      String badge,
      int jss,
      bool verified,
      int totalEarnings,
      int totalJobs,
      int totalHours,
      int freelancerRating,
      String about,
      List<String> skills,
      String? country,
      String? city,
      String? state,
      List<String> languages,
      List<Map<String, dynamic>> education,
      List<Map<String, dynamic>> portfolio,
      int seeds,
      List<Map<String, dynamic>> Reviews,
      List<Map<String, dynamic>> SavedJobs) async {
    await Server.FreelancerCollection.insertOne({
      'Image': image,
      'UserName': username,
      'Email': email,
      'Password': password,
      'Phone': phone,
      'FirstName': firstName,
      'LastName': lastName,
      'Title': title,
      'Badge': badge,
      'JSS': jss,
      'Verified': verified,
      'TotalEarnings': totalEarnings,
      'TotalJobs': totalJobs,
      'TotalHours': totalHours,
      'FreelancerRating': freelancerRating,
      'About': about,
      'Skills': skills,
      'Country': country,
      'City': city,
      'State': state,
      'Languages': languages,
      'Education': education,
      'Portfolio': portfolio,
      'Seeds': seeds,
      'Reviews': Reviews,
      'SavedJobs': SavedJobs
    });
    print("Data Inserted!!!");
  }

  static InsertClient(
    String image,
    String username,
    String email,
    String password,
    int phone,
    String firstName,
    String lastName,
    int TotalJobs,
    int JobsCompleted,
    int JobsInProgress,
    int TotalSpent,
    String? country,
    String? city,
    String? state,
    String CompanyEmail,
    String CompanyName,
    List<Map<String, dynamic>> Reviews,
  ) async {
    await Server.ClientCollection.insertOne({
      'Image': image,
      'UserName': username,
      'Email': email,
      'Password': password,
      'Phone': phone,
      'FirstName': firstName,
      'LastName': lastName,
      'TotalJobs': TotalJobs,
      'JobsCompleted': JobsCompleted,
      'JobsInProgress': JobsInProgress,
      'TotalSpent': TotalSpent,
      'Country': country,
      'City': city,
      'State': state,
      'CompanyEmail': CompanyEmail,
      'CompanyName': CompanyName,
      'Reviews': Reviews
    });
    print("Data Inserted!!!");
  }

  static Future<void> updateClient(
      String UserName,
      String name,
      int phone,
      String image,
      String Lastname,
      String CompanyEmail,
      String Companyname) async {
    print('Profile Updating');

    ClientFind['FirstName'] = name;
    ClientFind['Phone'] = phone;
    ClientFind['Image'] = image;
    ClientFind['LastName'] = Lastname;
    ClientFind['CompanyEmail'] = CompanyEmail;
    ClientFind['CompanyName'] = Companyname;

    Server.ClientCollection.update(
        where.eq("UserName", UserName), modify.set("FirstName", name));
    Server.ClientCollection.update(
        where.eq("UserName", UserName), modify.set("Phone", phone));
    Server.ClientCollection.update(
        where.eq("UserName", UserName), modify.set("Image", image));
    Server.ClientCollection.update(
        where.eq("UserName", UserName), modify.set("LastName", Lastname));
    Server.ClientCollection.update(where.eq("UserName", UserName),
        modify.set("CompanyEmail", CompanyEmail));
    Server.ClientCollection.update(
        where.eq("UserName", UserName), modify.set("CompanyName", Companyname));

    // Server.refresh();
    // UserFind = Server.FreelancersList?.firstWhereOrNull(
    //         (user) => user['UserName'] == UserName);
    print(ClientFind['FirstName']);

    print("Profile Updated!!!");
  }

  static Future<void> updateclientAddress(
      String UserName, String _Country, String _City, String _State) async {
    print('Profile Updating');
    ClientFind['Country'] = _Country;
    ClientFind['City'] = _City;
    ClientFind['State'] = _State;

    Server.ClientCollection.update(
        where.eq("UserName", UserName), modify.set("Country", _Country));
    Server.ClientCollection.update(
        where.eq("UserName", UserName), modify.set("City", _City));
    Server.ClientCollection.update(
        where.eq("UserName", UserName), modify.set("State", _State));

    // Server.refresh();
    // UserFind = Server.FreelancersList?.firstWhereOrNull(
    //         (user) => user['UserName'] == UserName);
    print(ClientFind['FirstName']);

    print("Profile Updated!!!");
  }

  static void InsertJobPost(
    String jobTitle,
    String jobDescription,
    String jobCategory,
    int jobBudget,
    int seedsRequired,
    List<String> skillsRequired,
    String expertiseLevel,
    var postingDate,
    String? FileName,
    String? File,
    String ClientUsername,
  ) async {
    var newJobPost = {
      "JobTitle": jobTitle,
      "JobDescription": jobDescription,
      "JobCategory": jobCategory,
      "Budget": jobBudget,
      "SeedsRequired": seedsRequired,
      "NoOfProposals": 0,
      "NoOfInvites": 0,
      "Invites": [],
      "Proposals": [],
      "SkillsRequired": skillsRequired,
      "ExpertiseLevel": expertiseLevel,
      "JobStatus": "open",
      "PostingDate": postingDate,
      "FileName": FileName,
      "File": File,
      "ClientUsername": ClientUsername,
    };

    print(newJobPost);

    Server.JobPostsList!.add(newJobPost);
    await Server.JobPostCollection.insertOne(newJobPost);

    (Server.ClientsList!.firstWhereOrNull(
        (client) => client['UserName'] == ClientUsername))!['TotalJobs'] += 1;
    (Server.ClientsList!.firstWhereOrNull((client) =>
        client['UserName'] == ClientUsername))!['JobsInProgress'] += 1;

    int tJ = (Server.ClientsList!.firstWhereOrNull(
        (client) => client['UserName'] == ClientUsername))!['TotalJobs'];

    int jIP = (Server.ClientsList!.firstWhereOrNull(
        (client) => client['UserName'] == ClientUsername))!['JobsInProgress'];

    await Server.ClientCollection.update(where.eq("UserName", ClientUsername),
        modify.set("TotalJobs", tJ).set("JobsInProgress", jIP));

    print("Data Inserted!!!");
  }

  static Future<bool> LoginUser(String username, String pass) async {
    UserFind = Server.FreelancersList?.firstWhereOrNull(
        (user) => user['UserName'] == username);

    print(Server.chatlist);

    if (UserFind != null && UserFind['Password'] == pass) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }


  static Future<void> updateuser(String UserName, String name, int phone,
      String image, String cat, String Lastname, String About) async {
    print('Profile Updating');

    UserFind['FirstName'] = name;
    UserFind['Phone'] = phone;
    UserFind['Image'] = image;
    UserFind['Title'] = cat;
    UserFind['LastName'] = Lastname;
    UserFind['About'] = About;

    Server.FreelancerCollection.update(
        where.eq("UserName", UserName), modify.set("FirstName", name));
    Server.FreelancerCollection.update(
        where.eq("UserName", UserName), modify.set("Phone", phone));
    Server.FreelancerCollection.update(
        where.eq("UserName", UserName), modify.set("Image", image));
    Server.FreelancerCollection.update(
        where.eq("UserName", UserName), modify.set("Title", cat));
    Server.FreelancerCollection.update(
        where.eq("UserName", UserName), modify.set("LastName", Lastname));
    Server.FreelancerCollection.update(
        where.eq("UserName", UserName), modify.set("About", About));

    // Server.refresh();
    // UserFind = Server.FreelancersList?.firstWhereOrNull(
    //         (user) => user['UserName'] == UserName);
    print(UserFind['FirstName']);

    print("Profile Updated!!!");
  }

  static Future<void> updateAddress(
      String UserName, String _Country, String _City, String _State) async {
    print('Profile Updating');
    UserFind['Country'] = _Country;
    UserFind['City'] = _City;
    UserFind['State'] = _State;

    Server.FreelancerCollection.update(
        where.eq("UserName", UserName), modify.set("Country", _Country));
    Server.FreelancerCollection.update(
        where.eq("UserName", UserName), modify.set("City", _City));
    Server.FreelancerCollection.update(
        where.eq("UserName", UserName), modify.set("State", _State));

    // Server.refresh();
    // UserFind = Server.FreelancersList?.firstWhereOrNull(
    //         (user) => user['UserName'] == UserName);
    print(UserFind['FirstName']);

    print("Profile Updated!!!");
  }

  static Future<void> insertskill(String UserName, String newSkill) async {
    print('New Skill: $newSkill');

    UserFind['Skills'].add(newSkill);

    Server.FreelancerCollection.update(where.eq("UserName", UserName),
        modify.set("Skills", UserFind['Skills']));
  }

  static Future<void> skilldelete(String UserName, String previousskill) async {
    print('New Skill: $previousskill');

    bool skillExists = false;
    for (int i = 0; i < UserFind['Skills'].length; i++) {
      if (UserFind['Skills'][i].toLowerCase() == previousskill.toLowerCase()) {
        UserFind['Skills'].removeAt(i); // Update the existing skill
        Server.FreelancerCollection.update(
          where.eq("UserName", UserName),
          modify.pull("Skills", previousskill),
        );
        skillExists = true;
        break;
      }
    }
    print(UserFind['Skills']);
  }

  static Future<void> skillupdate(
      String UserName, String newSkill, String previousskill) async {
    print('New Skill: $newSkill');

    bool skillExists = false;
    for (int i = 0; i < UserFind['Skills'].length; i++) {
      if (UserFind['Skills'][i].toLowerCase() == previousskill.toLowerCase()) {
        UserFind['Skills'][i] = newSkill; // Update the existing skill
        Server.FreelancerCollection.update(
          where.eq("UserName", UserName),
          modify.set("Skills.${i}", newSkill),
        );
        skillExists = true;
        break;
      }
    }
    print(UserFind['Skills']);
  }

  static Future<void> insertLanguages(
      String UserName, String newLanguage) async {
    print('New Language: $newLanguage');

    UserFind['Languages'].add(newLanguage);

    Server.FreelancerCollection.update(where.eq("UserName", UserName),
        modify.set("Languages", UserFind['Languages']));
  }

  static Future<void> Languageupdate(
      String UserName, String newLanguage, String previousLanguage) async {
    print('New Language: $newLanguage');

    bool skillExists = false;
    for (int i = 0; i < UserFind['Languages'].length; i++) {
      if (UserFind['Languages'][i].toLowerCase() ==
          previousLanguage.toLowerCase()) {
        UserFind['Languages'][i] = newLanguage; // Update the existing skill
        Server.FreelancerCollection.update(
          where.eq("UserName", UserName),
          modify.set("Languages.${i}", newLanguage),
        );
        skillExists = true;
        break;
      }
    }
    print(UserFind['Languages']);
  }

  static Future<void> Languagedelete(
      String UserName, String previousLanguage) async {
    print('New Languages: $previousLanguage');

    bool skillExists = false;
    for (int i = 0; i < UserFind['Languages'].length; i++) {
      if (UserFind['Languages'][i].toLowerCase() ==
          previousLanguage.toLowerCase()) {
        UserFind['Languages'].removeAt(i); // Update the existing skill
        Server.FreelancerCollection.update(
          where.eq("UserName", UserName),
          modify.pull("Languages", previousLanguage),
        );
        skillExists = true;
        break;
      }
    }
    print(UserFind['Languages']);
  }

  static Future<void> insertReviews(String contractid, String UserName,
      String Name, String clientusername, String comment, String rating) async {
    UserFind = Server.FreelancersList?.firstWhereOrNull(
        (user) => user['UserName'] == UserName);

    print(UserName + Name + clientusername + comment + rating.toString());

    var newReviews = {
      'contractID': contractid,
      'Name': Name,
      'clientUsername': clientusername,
      'comment': comment,
      'rating': rating,
    };

    print(newReviews);
    print(UserFind);

    print('New Review: $newReviews');

    UserFind['Reviews'].add(newReviews);
    ClientFind['Reviews'].add(newReviews);

    print(UserFind['Reviews']);

    double totalRating = 0.0;
    int count = 0;

    for (var reviews in CrudFunction.UserFind['Reviews']) {
      var rating = double.tryParse(reviews['rating']) ?? 0.0;
      totalRating += rating;
      count++;
    }

    double averageRating = count > 0 ? totalRating / count : 0.0;

    print('The average rating is: $averageRating');

    print(UserFind['JobsCompleted'] + 1);
    int JobsCompleted = UserFind['JobsCompleted'] + 1;
    int jobsinprogress = UserFind['JobsInProgress'] - 1;
    var add = JobsCompleted / (UserFind['TotalJobs'] - jobsinprogress);
    var jss = add * 100;
    print(UserFind['JSS'] + 1);
    print(jss);

    Server.FreelancerCollection.update(where.eq("UserName", UserName),
        modify.set("Reviews", UserFind['Reviews']));
    Server.FreelancerCollection.update(where.eq("UserName", UserName),
        modify.set("JobsInProgress", jobsinprogress.round()));
    Server.FreelancerCollection.update(where.eq("UserName", UserName),
        modify.set("JobsCompleted", JobsCompleted));
    Server.FreelancerCollection.update(
        where.eq("UserName", UserName), modify.set("JSS", jss));
    Server.FreelancerCollection.update(where.eq("UserName", UserName),
        modify.set("FreelancerRating", averageRating.round()));

    Server.ClientCollection.update(where.eq("UserName", clientusername),
        modify.set("Reviews", ClientFind['Reviews']));
    Server.ClientCollection.update(where.eq("UserName", clientusername),
        modify.set("JobsInProgress", jobsinprogress));
    Server.ClientCollection.update(where.eq("UserName", clientusername),
        modify.set("JobsCompleted", JobsCompleted));

    UserFind = null;
    print(UserFind);
  }

  static Future<void> insertsavedjobs(String UserName, String jobid,
      String jobname, String proposalslimit) async {
    print(jobid + jobname + proposalslimit);

    var newsavedjobs = {
      'jobid': jobid,
      'jobname': jobname,
      'proposalslimit': proposalslimit,
    };

    filteredFRJobs!.add(newsavedjobs);

    print('New Language: $newsavedjobs');

    UserFind['SavedJobs'].add(newsavedjobs);

    Server.FreelancerCollection.update(where.eq("UserName", UserName),
        modify.set("SavedJobs", UserFind['SavedJobs']));
  }

  static Future<void> deletesavedjobs(String UserName, String jobid,
      String jobname, String proposalslimit) async {
    var deepEq = DeepCollectionEquality();
    print(jobid + jobname + proposalslimit);
    var newsavedjobs = {
      'jobid': jobid,
      'jobname': jobname,
      'proposalslimit': proposalslimit,
    };
    for (int index = 0; index < UserFind['SavedJobs'].length; index++) {
      print(index);
      print(UserFind['SavedJobs'][index]);
      print(newsavedjobs);
      if (deepEq.equals(newsavedjobs, UserFind['SavedJobs'][index])) {
        if (index >= 0 && index < UserFind['SavedJobs'].length) {
          filteredFRJobs!.removeAt(index);

          UserFind['SavedJobs'].removeAt(index); // Update the existing skill
          Server.FreelancerCollection.update(where.eq("UserName", UserName),
              modify.pull("SavedJobs", newsavedjobs));
        }
      }
    }
    print(UserFind['SavedJobs']);
  }

  static Future<void> insertEducation(String UserName, String collegeName,
      String major, String duration) async {
    var newEducation = {
      'CollegeName': collegeName,
      'Major': major,
      'Duration': duration,
    };

    print('New Language: $newEducation');

    UserFind['Education'].add(newEducation);

    Server.FreelancerCollection.update(where.eq("UserName", UserName),
        modify.set("Education", UserFind['Education']));
  }

  static Future<void> deleteEducation(String UserName, String collegeName,
      String major, String duration, int index) async {
    var newEducation = {
      'CollegeName': collegeName,
      'Major': major,
      'Duration': duration,
    };
    if (index >= 0 && index < UserFind['Education'].length) {
      UserFind['Education'].removeAt(index); // Update the existing skill
      Server.FreelancerCollection.update(where.eq("UserName", UserName),
          modify.pull("Education", newEducation));
    }

    print(UserFind['Education']);
  }

  static Future<void> updateEducation(String UserName, String collegeName,
      String major, String duration, int index) async {
    var newEducation = {
      'CollegeName': collegeName,
      'Major': major,
      'Duration': duration,
    };
    if (index >= 0 && index < UserFind['Education'].length) {
      UserFind['Education'][index] = newEducation; // Update the existing skill
      Server.FreelancerCollection.update(where.eq("UserName", UserName),
          modify.set("Education.${index}", newEducation));
    }

    print(UserFind['Education']);
  }

  static Future<void> insertPortfolio(
      String UserName, String image, String title) async {
    var newPortfolioEntry = {
      'Image': image,
      'Title': title,
    };
    UserFind['Portfolio'].add(newPortfolioEntry);

    print('Updating DB');
    Server.FreelancerCollection.update(where.eq("UserName", UserName),
        modify.set("Portfolio", UserFind['Portfolio']));
    print('DB Updated');
  }

  static Future<void> updatePortfolio(
      String UserName, String image, String title, int index) async {
    var newPortfolioEntry = {
      'Image': image,
      'Title': title,
    };

    if (index >= 0 && index < UserFind['Portfolio'].length) {
      UserFind['Portfolio'][index] =
          newPortfolioEntry; // Update the existing skill
      Server.FreelancerCollection.update(where.eq("UserName", UserName),
          modify.set("Portfolio.${index}", newPortfolioEntry));
    }

    print(UserFind['Portfolio']);
  }

  static Future<void> deletePortfolio(
      String UserName, String image, String title, int index) async {
    var newPortfolioEntry = {
      'Image': image,
      'Title': title,
    };

    if (index >= 0 && index < UserFind['Portfolio'].length) {
      UserFind['Portfolio'].removeAt(index); // Update the existing skill
      Server.FreelancerCollection.update(where.eq("UserName", UserName),
          modify.pull("Portfolio", newPortfolioEntry));
    }

    print(UserFind['Portfolio']);
  }

  static Future<void> updatepass(String UserName, String pass) async {
    print('name ' + pass);
    print('UserName ' + UserName);

    await Server.FreelancerCollection.update(
        where.eq("UserName", UserName), modify.set("Password", pass));
  }

  static Future<bool> LoginClient(String username, String pass) async {
    ClientFind = Server.ClientsList?.firstWhereOrNull(
        (client) => client['UserName'] == username);

    if (ClientFind != null && ClientFind['Password'] == pass) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  static int Finder(String username, String email) {
    final uNameFind = Server.FreelancersList?.firstWhereOrNull(
        (user) => user['UserName'] == username);
    final uEmailFind = Server.FreelancersList?.firstWhereOrNull(
        (user) => user['Email'] == email);
    if (uNameFind != null) {
      return 1;
    } else if (uEmailFind != null) {
      return 2;
    } else {
      return 0;
    }
  }

  static int ClientFinder(String username, String email) {
    final uNameFind = Server.ClientsList?.firstWhereOrNull(
        (user) => user['UserName'] == username);
    final uEmailFind =
        Server.ClientsList?.firstWhereOrNull((user) => user['Email'] == email);
    print(uNameFind);
    if (uNameFind != null) {
      return 1;
    } else if (uEmailFind != null) {
      return 2;
    } else {
      return 0;
    }
  }

  static SubmitProposal(
      ObjectId JobID,
      String ClientUsername,
      String FreelancerUsername,
      int BidAmount,
      String CoverLetter,
      bool ContractSent,
      List<Map<String, dynamic>> Files) async {
    print("Entered to the function");
    var newProp = {
      'JobID': JobID,
      'ClientUsername': ClientUsername,
      'FreelancerUsername': FreelancerUsername,
      'BidAmount': BidAmount,
      'CoverLetter': CoverLetter,
      'ContractSent': ContractSent,
      'ProposalStatus': 'sent',
      'Files': Files,
    };

    Server.ProposalsList!.add(newProp);

    Server.ProposalsCollection.insertOne(newProp);

    CrudFunction.currentJob!['Proposals'].add(newProp);

    CrudFunction.UserFind['Seeds'] -= CrudFunction.currentJob!['SeedsRequired'];

    Server.FreelancerCollection.update(
        where.eq("UserName", CrudFunction.UserFind['UserName']),
        modify.set("Seeds", CrudFunction.UserFind!['Seeds']));

    await Server.JobPostCollection.update(
        where.eq("_id", JobID),
        modify.set(
            "NoOfProposals", CrudFunction.currentJob!['NoOfProposals'] + 1));

    await Server.JobPostCollection.update(where.eq("_id", JobID),
        modify.set("Proposals", CrudFunction.currentJob!['Proposals']));

    Server.refresh();

    print("Proposal Submitted Done");
  }

  static WithdrawProposal(var proposal) async {
    print('Withdrawing Proposal');

    await Server.ProposalsCollection.deleteOne(
        where.eq('_id', proposal['_id']));

    bool abc = Server.ProposalsList!.remove(proposal);
    print(abc);

    var ab = CrudFunction.fr_thatJob['Proposals'].firstWhere(
        (element) => element['_id'] == proposal['_id'],
        orElse: () => null);

    CrudFunction.fr_thatJob['Proposals'].remove(ab);

    await Server.JobPostCollection.update(
        where.eq("_id", CrudFunction.fr_thatJob['_id']),
        modify.set("Proposals", CrudFunction.fr_thatJob['Proposals']));
    await Server.JobPostCollection.update(
        where.eq("_id", CrudFunction.fr_thatJob['_id']),
        modify.set(
            "NoOfProposals", CrudFunction.fr_thatJob['NoOfProposals'] - 1));

    Server.refresh();

    print('Proposal Withdrawn');
  }

  static DeclineProposal(ObjectId propID, ObjectId jobID) async {
    print('Declining');

    var toRemoveProp =
        Server.ProposalsList!.firstWhereOrNull((prop) => prop['_id'] == propID);
    bool abc = filteredProposals!.remove(toRemoveProp);
    print("Removed: ${abc}");

    int indexOfProp =
        Server.ProposalsList!.indexWhere((prop) => prop['_id'] == propID);
    if (indexOfProp != -1) {
      print('1');
      Server.ProposalsList![indexOfProp]['ProposalStatus'] = 'declined';
    }

    int indexOfJob =
        Server.JobPostsList!.indexWhere((job) => job['_id'] == jobID);
    if (indexOfJob != -1) {
      print('2');
      print(
          'ProposalNum: ${Server.JobPostsList![indexOfJob]['NoOfProposals']}');
      Server.JobPostsList![indexOfJob]['NoOfProposals'] -= 1;
      print(
          'ProposalNum: ${Server.JobPostsList![indexOfJob]['NoOfProposals']}');
    }

    for (var item in Server.JobPostsList![indexOfJob]['Proposals']) {
      print('3');
      if (item['_id'] == propID) {
        print('4');
        item['ProposalStatus'] = 'declined';
      }
    }
    print('5');
    await Server.JobPostCollection.update(
        where.eq('_id', jobID),
        modify.set('NoOfProposals',
            Server.JobPostsList![indexOfJob]['NoOfProposals']));

    await Server.JobPostCollection.update(where.eq('_id', jobID),
        modify.set('Proposals', Server.JobPostsList![indexOfJob]['Proposals']));

    await Server.ProposalsCollection.update(
        where.eq("_id", propID), modify.set("ProposalStatus", 'declined'));

    Server.refresh();

    print('Finish Declining');
  }

  static InsertChat(
      String clientname,
      String freelancername,
      ObjectId jobid,
      String Proposalid,
      List<Map<String, dynamic>> messages,
      String date,
      String session) async {
    final collection = db.collection(CHAT_COLLECTION);
    var _id = ObjectId();
    print(clientname + freelancername + _id.toString());
    await collection.insertOne({
      'ClientName': clientname,
      'FreelancerName': freelancername,
      'JobID': jobid,
      'ProposalId': Proposalid,
      'Messages':
          messages, // Change 'Message' field to 'Messages' field with nested array
      'Date': date,
      'Session': session,
    });
    print("Data Inserted!!!");

  }

  static void resetPassword(String email, String pass, bool isClient) async {
    print("Updating Password");
    print('Password ' + pass);
    print('Email ' + email);
    print('Client: ${isClient}');

    if (isClient == false) {
      print('In Freelancer');
      await Server.FreelancerCollection.update(
          where.eq("Email", email), modify.set("Password", pass));
    } else {
      print('In Client');
      await Server.ClientCollection.update(
          where.eq("Email", email), modify.set("Password", pass));
    }

    await Server.refresh();

    print("Password Updated");
  }
}
