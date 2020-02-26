/******************************
   @Author: Sumit Choubey
   @Date:
   @Description: 
   @version update: 1.0 February-1-2020 @sumit choubey 
   ****************************/
trigger CaseTrigger on Case (before delete, before insert, before update, 
                             after delete,  after insert,  after update) {

     If(Trigger.isBefore && Trigger.isUpdate) {
       //*** Call to Apex Handler ***// 
       CaseTriggerHandler.getPreviousOwnerName(Trigger.newMap, Trigger.OldMap);
     }
}
