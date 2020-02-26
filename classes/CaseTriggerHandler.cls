/******************************
   @Author: Sumit Choubey
   @Date: 
   @Test class:
   @Description: 
   @version update: 1.0 February-1-2020 @sumit choubey 
   ****************************/
 
public with sharing class CaseTriggerHandler {

 /***
    @Input:- this method take input from Trigger(new value and Old values)
    @Return:- this method returns null
    @Description:- 
    ***/
 public static Case getPreviousOwnerName (Map<Id, Case> newmapvalue, 
                                          Map<Id, Case> oldmapvalue) {

  Set<Id> userId = new Set<Id>();
  Set<Id> queueId = new Set<Id>();

  For(Case thisCase : newmapvalue.values()) {
    case oldCase = oldmapvalue.get(thisCase.Id);
    If(thisCase.OwnerId != oldCase.OwnerId && oldCase.OwnerId != null) {
      If(oldCase.OwnerID.getsObjectType() == User.sObjectType) {
        userId.add(oldCase.OwnerId);
      }
      else {
        queueId.add(oldCase.OwnerId);
      }
    }
  }
 
  /*** @get old owner(user) ***/
  Map<Id, User> usermap = new Map<Id, User>([SELECT Id, 
                                                    Name, 
                                                    Email 
                                             FROM User 
                                             WHERE Id IN: userId]);
 
  /*** @get old owner(queue) ***/
  Map<Id, Group> groupmap = new Map<Id, Group>([SELECT Id, 
                                                       Name 
                                                FROM Group 
                                                WHERE Id IN: queueId AND type ='Queue']);
    
  /*** @set old user or old queue name ***/
  For(case thiscase : newmapvalue.values()) {
    case oldCase = oldmapvalue.get(thiscase.Id); 
    If(thisCase.OwnerId != oldCase.OwnerId) {
      If(oldCase.OwnerID.getsObjectType() == User.sObjectType && oldCase.OwnerId != null && usermap.get(oldCase.OwnerId) != null) {
        thisCase.Previous_User_Name__c = usermap.get(oldCase.OwnerId).Name;
      } else If(groupmap.get(oldCase.OwnerId) != null) {
        thisCase.Privous_Queue_Name__c = groupmap.get(oldCase.OwnerId).Name;
      }
    }
  }
  return null;
 }
}
