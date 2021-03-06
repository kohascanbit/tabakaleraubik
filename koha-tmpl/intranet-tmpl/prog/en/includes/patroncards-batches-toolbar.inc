<div id="toolbar">
    <script type="text/JavaScript">
        //<![CDATA[
           function DeleteConfirm() {
                var msg = "Are you sure you want to delete batch [% batch_id %]?"
                var answer = confirm(msg);
                if (answer) {
                    window.location = "/cgi-bin/koha/patroncards/manage.pl?op=delete&amp;card_element=batch&amp;element_id=[% batch_id %]";
                }
                else {
                    return; // abort delete
                }
            };
            function Remove() {
                items = new Array;
                item_num = new Array;
                if(document.items.action.length > 0) {
                    for (var i=0; i < document.items.action.length; i++) {
                        if (document.items.action[i].checked) {
                            items.push("label_id=" +  document.items.action[i].value);
                            item_num.push(i+1);
                        }
                    }
                    if (items.length < 1) {
                        alert(_("Please select at least one item to delete."));
                        return;     // no item selected
                    }
                    getstr = items.join("&");
                    item_msg = item_num.join(", ");
                    var msg = "Are you sure you want to remove card number(s): " + item_msg + " from this batch?"
                }
//                else if (document.items.action.checked) {
//                    getstr = "label_id="+document.items.action.value;
//                    var msg = "Are you sure you want to remove selected item from this batch?"
//                }
                else {
                    alert(_("Please select at least label to delete."));
                    return;     // no item selected
                }
                var answer = confirm(msg);
                if (answer) {
                    window.location = "/cgi-bin/koha/patroncards/edit-batch.pl?op=remove&amp;batch_id=[% batch_id %]&amp;" + getstr;
                }
                else {
                    return; // abort delete
                }
            };
            function Add() {
                window.open("/cgi-bin/koha/patroncards/members-search.pl?batch_id=[% batch_id %]",'FindABibIndex','width=875,height=400,toolbar=no,scrollbars=yes');
            };
            function DeDuplicate() {
                window.location = "/cgi-bin/koha/patroncards/edit-batch.pl?op=de_duplicate&amp;batch_id=[% batch_id %]";
            };
            function Xport(mode) {
                if (mode == 'label') {
                    patroncards= new Array;
                    if(document.items.action.length > 0) {
                        for (var i=0; i < document.items.action.length; i++) {
                            if (document.items.action[i].checked) {
                                patroncards.push("label_id=" +  document.items.action[i].value);
                            }
                        }
                        if (patroncards.length < 1) {
                            alert(_("Please select at least one card to export."));
                            return;     // no batch selected
                        }
                        getstr = patroncards.join("&");
                    }
                    else if (document.items.action.checked) {
                        getstr = document.items.action.value;
                    }
                    else {
                        alert(_("Please select at least one card to export."));
                        return;     // no batch selected
                    }
                    return GB_showCenter('Export labels', "/cgi-bin/koha/patroncards/print.pl?batch_id=[% batch_id %]&" + getstr, 700, 800);
                }
                else if (mode == 'batch') {
                    return GB_showCenter('Export labels', "/cgi-bin/koha/patroncards/print.pl?batch_id=[% batch_id %]", 700, 800);
                }
                else {
                    // some pass-thru error trapping just in case...
                }
            };
           function selected_layout() {
                if (document.items.action.length) {
                for (i=0;i<document.items.action.length;i++){
                    if (document.items.action[i].checked==true){
                        return(document.items.action[i].value);
                    }
                };
                }
                else {
                    if (document.items.action.checked){
                        return(document.items.action.value);
                    }
                };
                alert(_("Please select at least one item."));
                return (-1);
            };

        // prepare DOM for YUI Toolbar
         $(document).ready(function() {
            $("#additemsc").empty();
            $("#removeitemsc").empty();
            $("#deletebatchc").empty();
            $("#deduplicatec").empty();
            $("#exportitemsc").empty();
            $("#exportbatchc").empty();
            yuiToolbar();
         });
        // YUI Toolbar Functions
        function yuiToolbar() {
            new YAHOO.widget.Button({
                id: "additems",
                type: "link",
                href: "#",
                label: _("Add item(s)"),
                container: "additemsc",
                onclick: {fn:function(){Add()}}
            });

            new YAHOO.widget.Button({
                id: "removeitems",
                type: "link",
                href: "#",
                label: _("Remove item(s)"),
                container: "removeitemsc",
                onclick: {fn:function(){Remove()}}
            });

            new YAHOO.widget.Button({
                id: "deletebatch",
                type: "link",
                href: "#",
                label: _("Delete batch"),
                container: "deletebatchc",
                onclick: {fn:function(){DeleteConfirm()}}
            });

            new YAHOO.widget.Button({
                id: "deduplicate",
                type: "link",
                href: "#",
                label: _("Remove duplicates"),
                container: "deduplicatec",
                onclick: {fn:function(){DeDuplicate()}}
            });

            new YAHOO.widget.Button({
                id: "exportitems",
                type: "link",
                href: "#",
                label: _("Export item(s)"),
                container: "exportitemsc",
                onclick: {fn:function(){Xport('label')}}
            });

            new YAHOO.widget.Button({
                id: "exportbatch",
                type: "link",
                href: "#",
                label: _("Export batch"),
                container: "exportbatchc",
                onclick: {fn:function(){Xport('batch')}}
            });
            new YAHOO.widget.Button("deletebatch");
        }
        //]]>
    </script>
    <ul class="toolbar">
        <li id="additemsc"><a id="additems" href="#">Add item(s)</a></li>[% IF ( table_loop ) %]
        <li id="removeitemsc"><a id="removeitems" href="#">Remove item(s)</a></li>
        <li id="deletebatchc"><a id="deletebatch" href="#">Delete batch</a></li>
        <li id="deduplicatec"><a id="deduplicate" href="#">Remove duplicates</a></li>
        <li id="exportitemsc"><a id="exportitems" href="#">Export item(s)</a></li>
        <li id="exportbatchc"><a id="exportbatch" href="#">Export batch</a></li>[% END %]
    </ul>
</div>
