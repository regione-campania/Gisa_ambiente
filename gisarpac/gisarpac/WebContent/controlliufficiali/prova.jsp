<a href="#" style="display:none;visibility:hidden;" 
   onclick="return false" ID="dummyLink" runat="server">dummyasdasda</a>

   <ajaxToolkit:ModalPopupExtender ID="MyMPE" runat="server"
    TargetControlID="dummyLink"
    PopupControlID="EditorPanel"
    BackgroundCssClass="modalBackground" 
    DropShadow="true" 
    BehaviourID="MyMPE"
    OkControlID="OkButton"
    CancelControlID="CancelButton"> 
</ajaxToolkit:ModalPopupExtender>
   <script>
   $find('MyMPE').show();
   
   </script>