function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) === ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) === 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}

function showIoLog(animate) {
    //console.log('animate='+animate);
    if (animate==0) {
        $(".l-content .l-center").css("margin-right", 240);
        $(".to-top").css("right", 285);
        $(".to-shortcuts").css("right", 330);
        $(".io-log").css("right", 0);
        $(".io-log2").css("right", 0);
        //$("#myvesta_float").css("margin-right", 280);
    } else {
        $(".l-content .l-center").animate({"margin-right": 240});
        $(".to-top").animate({"right": 285});
        $(".to-shortcuts").animate({"right": 330});
        $(".io-log").animate({"right": 0});
        $(".io-log2").animate({"right": 0});
        //$("#myvesta_float").animate({"margin-right": 280});
    }

    /*
    $.ajax({url: "/list/log/", success: function(result){
            $( ".io-log div" ).remove();
            $($(result).find('.l-center.units')).insertAfter(".io-log h2");
            $( ".io-log div" ).removeClass();
    }});
    */
}

function hideIoLog(animate){
    //console.log('animate='+animate);
    if (animate==0) {
        $(".l-content .l-center").css("margin-right", 40);
        $(".to-top").css("right", 85);
        $(".to-shortcuts").css("right", 130);
        $(".io-log").css("right", -200);
        $(".io-log2").css("right", -200);
        $("#myvesta_float").css("margin-right", 100);
    } else {
        $(".l-content .l-center").animate({"margin-right": 40});
        $(".to-top").animate({"right": 85});
        $(".to-shortcuts").animate({"right": 130});
        $(".io-log").animate({"right": -200});
        $(".io-log2").animate({"right": -200});
        $("#myvesta_float").animate({"margin-right": 100});
    }
}

function checkCookie() {
    iolog = getCookie("iolog");
    //console.log('cookie: "'+iolog+'"');
    if (iolog === '1') {
        return 1;
    }
    if (iolog === '0') {
        return 0;
    }
    if (iolog == '') {
        //console.log('cookie is empty');
        return '';
    }
}

// function getRandomInt(max) {
//   return Math.floor(Math.random() * max);
// }
// var randomnumber=getRandomInt(100000000);
var iohtml = '<div class="io-box clearfix">\n' +
    '        <div class="io-box-left clearfix">\n' +
    '          <div class="io-box-left-items io-1-homepage-block">\n' +
    '            <a href="https://www.myvestacp.com/" target="_blank">myVesta</a>\n' +
    '            <span class="io-description">website</span>\n' +
    '          </div>\n' +
    '          <div class="io-box-left-items io-2-homepage-block">\n' +
    '            <a href="https://forum.myvestacp.com/" target="_blank">Forum</a>\n' +
    '            <span class="io-description">Ask the questions on our forum</span>\n' +
    '          </div>\n' +
    '          <div class="io-box-left-items io-3-homepage-block">\n' +
    '            <a href="https://github.com/myvesta/vesta" target="_blank">Git</a>\n' +
    '            <span class="io-description">Become our code contributor</span>\n' +
    '          </div>\n' +
    '          <div class="io-box-left-items io-4-homepage-block">\n' +
    '            <a href="https://forum.myvestacp.com/viewtopic.php?t=814" target="_self">Donate</a>\n' +
    '            <span class="io-description">Buy us a coffe</span>\n' +
    '          </div>\n' +
    '          <div class="io-box-left-items io-5-homepage-block">\n' +
    '            <a href="https://wiki.myvestacp.com/" target="_self">Wiki</a>\n' +
    '            <span class="io-description">Find solution in our documentation</span>\n' +
    '          </div>\n' +
    '        </div>\n' +
    '        <div class="io-box-right io-banner clearfix">\n' +
    '          <a href="/list/rrd/"><img src="/list/rrd/image.php?/rrd/la/daily-la.png" alt="SysLoad"></a>\n' +
    '        </div>\n' +
    '      </div>';

$(document).ready(function(){
    var sys_height=$(".io-log").height();
    $(".io-log2").css("top", sys_height+50);
    setTimeout(function() {
        iolog = getCookie("iolog");
        //console.log('cookie: "'+iolog+'"');
        if (iolog === '1') {
            showIoLog(0);
            return 1;
        }
        if (iolog === '0') {
            //setCookie("iolog", 0, 365);
            hideIoLog(0);
            return 0;
        }
        if (iolog == '') {
            //console.log('cookie is empty');
            //setCookie("iolog", 1, 365);
            showIoLog(0);
            return '';
        }
    }, 1);

    if (GLOBAL.CURRENT_USER_FINAL == 'admin') $(".body-user .l-content > .l-center.units").first().prepend( iohtml );

    $(".io-log").on("click", function() {
        var showlog=checkCookie();
        //console.log('cookie = "'+iolog+'"');
        if (showlog===1 || showlog=='') {
            //console.log('cookie is active or empty, calling hidelog()');
            setCookie("iolog", 0, 365);
            hideIoLog(1);
        }
        if (showlog===0) {
            //console.log('cookie is inactive, calling showlog()');
            setCookie("iolog", 1, 365);
            showIoLog(1);
        }

    });
});

