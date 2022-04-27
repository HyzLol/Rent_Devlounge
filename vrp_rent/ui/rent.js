$(function(){
    let rent = false;
    let arr = [];

    let i = 0
    $("#rent").hide();
    window.addEventListener("message",function(event) {
        var item = event.data;
        if (item.veh != null || item.veh != undefined) {
            arr = item.veh
        }
        if (item.show) {
            rent = true;
            SetSlot(i)  
            $("#rent").fadeIn()
        } else {
            rent = false;
            $("#rent").fadeOut()
            i = 0;
        }
    })
    SetSlot = function(i) {
        $("#photo").attr("src",arr[i].img)
        $("#veh-name").text(arr[i].veh.toUpperCase())
        $("#price").text("Price | "+arr[i].price+"$")
        let minutes = Math.floor(arr[i].timer / 60)
        if (minutes < 10) {
            minutes = "0"+minutes   
        }
        let seconds = arr[i].timer % 60
        if (seconds  < 10) {
            seconds = "0"+seconds   
        }
        $("#time").text("Timer | "+minutes+":"+seconds)
    }

    $(".selector-s").click(function(){
        if (rent == true) {
            if ($(this).attr("value") == "right") {
                if (i < arr.length - 1) {
                    i = i+1
                    SetSlot(i)
                }
            } else {
                if (i >= 1) {
                    i = i - 1
                    SetSlot(i)
                }
            }
        }
    });

    $("#rent-bt").click(function(){
        if (rent == true) {
            $.post('http://vrp_rent/exit', JSON.stringify({close : false,veh : arr[i].veh}));
        }
    });

    window.onkeyup = function (data) {
        if (data.which == 27) {
            if (rent == true) {
                $.post('http://vrp_rent/exit', JSON.stringify({close : true}));
            }
            return;
        }
    };
})
