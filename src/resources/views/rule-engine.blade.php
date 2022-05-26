<!DOCTYPE HTML>
<html lang="en-US">
<head>
    <title>HTML5 Local Storage Project</title>
    <META charset="UTF-8">
    <META name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <META NAME='rating' CONTENT='General'/>
    <META NAME='expires' CONTENT='never'/>
    <META NAME='language' CONTENT='English, EN'/>
    <META name="description" content="shopping cart project with HTML5 and JavaScript">
    <META name="keywords" content="HTML5,CSS,JavaScript, html5 session storage, html5 local storage">
    <META name="author" content="dcwebmakers.com">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script src="{{asset('Storage.js')}}"></script>
    <link rel="stylesheet" href="{{asset('StorageStyle.css')}}">
</head>


<body onload="doShowAll()">
<h2>Shopping Cart</h2>
<p>Insert items and quantity for your shopping cart. </p>
<form name=ShoppingList>

    <div id="main">
        <table>
            <tr>

                <td><b>Item:</b><input type=text name=name></td>
                <td><b>Quantity:</b><input type=number name=data></td>

            </tr>

            <tr>
                <td>
                    <input type=button value="Save" onclick="SaveItem()">
                    <input type=button value="Update" onclick="ModifyItem()">
                    <input type=button value="Delete" onclick="RemoveItem()">
                </td>
            </tr>

            <td>
                <input type="radio" name="repeating_customer" id="repeating_customer" value="1">
                <label for="repeating_customer">Repeating Customer</label><br>
            </td>

            <td>
                <input type="radio" name="repeating_customer" id="never_ordered" value="1">
                <label for="never_ordered">Never Ordered Before</label><br>
            </td>

            {{--            <td><b>Repeating Customer:</b><input type=checkbox id="repeating_customer" name=repeating_customer></td>--}}
{{--            <td><b>Never Ordered Before:</b><input type=checkbox id="never_ordered" name=never_ordered></td>--}}
            <td><b>Promo Code:</b><input type=text id="promo_code" name=promo_code></td>

        </table>
    </div>

    <div id="items_table">
        <h3>Shopping List</h3>
        <table id=list></table>
        <p>
            <label><input type=button value="Clear Cart" onclick="ClearAll()">
                <label><input type=button value="Submit" onclick="validate()">
        </p>

        <div id="result">

        </div>
    </div>

</form>

</body>
</html>
<script>
    function validate() {
        console.log(localStorage);
        $.ajax({
            url: "/validate",
            type: "POST",
            data: {
                "_token": "{{ csrf_token() }}",
                'cart': JSON.stringify(localStorage),
                // 'repeating_customer': $('#repeating_customer').prop("checked"),
                'never_ordered': $('#never_ordered:checked').val(), //$('#never_ordered').prop("checked"),
                'repeating_customer': $('#repeating_customer:checked').val(),
                'promo_code': $('#promo_code').val(),
            },
            success: function (html) {
                console.log(html['string'])
                $("#result").html(html['string']);
            }
        });

    }

</script>
