$.fn.appendToWithIndex=function(to,index){
    if(! to instanceof jQuery){
        to=$(to);
    };
    if(index===0){
        $(this).prependTo(to)
    }else{
        $(this).insertAfter(to.children().not('.detail-expanded').eq(index-1));
    }
};

function mapInitialize(map_) {
    var coords_ = $('#'+ map_).data('coords');
    var marker_ = $('#'+ map_).data('marker');
    var center_ = $('#'+ map_).data('center');
    if (coords_){
        var tmpCoords = coords_.split(',');
        var latitude = tmpCoords[0];
        var longtitude = tmpCoords[1];
    }

    var latlng = new google.maps.LatLng(latitude,longtitude);

    var myOptions = {
        zoom: 16,
        center: latlng,
        disableDefaultUI: true,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    var map = new google.maps.Map(document.getElementById(map_), myOptions);

    var marker = new google.maps.Marker({
        position: latlng,
        map: map
    });



    map.setCenter(latlng);
    google.maps.event.addDomListener(window, 'resize', function(){
        map.setCenter(latlng);
    });
}

jQuery(document).ready(function($) {

    var isMobile = (function(a){return /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4))})(navigator.userAgent||navigator.vendor||window.opera);
    var isTouchDevice = 'ontouchstart' in document.documentElement;

    var isMobile2 = function () {
        try{ document.createEvent("TouchEvent"); return true; }
        catch(e){ return false; }
    }
    document.body.className = document.body.className.replace("no-js","js");

    document.body.classList.add('loaded');
    var menuOpen = false;

    var wW = $(window).width();
    var $bgvid = document.getElementById('bgvid');

    if (wW >= 768 && $bgvid !== null){
        $bgvid.play();
        $bgvid.addEventListener('ended',function () {
            var headerHeight = $('.navbar').length? $('.navbar').outerHeight():0;
            var target = $('#home-grid');
            if (target.length) {
                $('html,body').animate({
                    scrollTop: target.offset().top-headerHeight
                }, 1000);
            }
        } ,false);
    }

    function setEqHeight() {

        equalheight(".box-map .map, .box-map .map-right");
    }

    $('.map').each(function(){
        var map_ = $(this).attr('id');
        mapInitialize(map_);
    });

    $('a[href*=#]:not([href=#]).btn-scroller').click(function() {
        var headerHeight = $('.navbar').length? $('.navbar').outerHeight():0;
        if($(this).hasClass('not-scroller')) return false;

        if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
            var target = $(this.hash);
            target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
            if (target.length) {
                $('html,body').animate({
                    scrollTop: target.offset().top-headerHeight
                }, 1000);
                return false;
            }
        }
    });
    
    $('.bgvid-play').on('click', function (e) {
        e.preventDefault();
        var container = $('.bg-video-container');
        if (container.length && $bgvid !== null){
            container.fadeIn('slow', function (e) {
                $bgvid.play();
                $bgvid.addEventListener('ended',function () {
                    container.fadeOut('slow');
                    var headerHeight = $('.navbar').length? $('.navbar').outerHeight():0;
                    var target = $('#home-grid');
                    if (target.length) {
                        $('html,body').animate({
                            scrollTop: target.offset().top-headerHeight
                        }, 1000);
                    }
                } ,false);
            });
        }
    });


    $('.active-blog-close').on('click', function(){
        $('.blog-item-active').hide();

        return false;
    });

    initMenuDropdown = function () {
        var container = $('.sidebar .sibebar-menu-expand'),
            current = container.find('.current-menu-item > a'),
            currentAnchor = current.text(),
            //menu = container.find('> ul'),
            append = ("<div class='sidebar-menu-mobile'><div class='menu-header'>"+currentAnchor+"</div><div class='menu-body'>"+container.html()+"</div></div>");
        container.append(append);
        container.find('.menu-header').on('click', function (e) {
            e.preventDefault();
            container.find('.menu-body').slideDown();
            $('body').append("<div class='sidebar-menu-mobile-overlay'></div>");

        })
    }
    
    $('body').on("click", ".sidebar-menu-mobile-overlay", function (e) {
        e.preventDefault();
        $(this).remove();
        $(".sidebar-menu-mobile .menu-body").slideUp();
    });

    $('body').on('click', '.sidebar-menu-mobile .current-menu-item > a', function (e) {
        e.preventDefault();
        $('.sidebar-menu-mobile-overlay').remove();
        $(".sidebar-menu-mobile .menu-body").slideUp();
    });

    initModal = function () {

        var appendthis =  ("<div class='modal-overlay js-modal-close'></div>");

        $('a[data-modal-id]').click(function(e) {
            e.preventDefault();
            $("body").append(appendthis);
            $("body").addClass('popuped');
            $(".modal-overlay").fadeTo(500, 0.7);
            //$(".js-modalbox").fadeIn(500);
            var modalBox = $(this).attr('data-modal-id');
            $('#'+modalBox).fadeIn($(this).data());
            $('#'+modalBox).find('.modal-body').mCustomScrollbar();
        });


        $("body").on("click", ".js-modal-close, .modal-overlay", function(e) {
            e.preventDefault();
            $(".modal-box, .modal-overlay").fadeOut(500, function() {
                $(".modal-overlay").remove();
                $("body").removeClass('popuped');
            });
        });

        $(window).resize(function() {
            $(".modal-box").css({
                top: ($(window).height() - $(".modal-box").outerHeight()) / 2,
                left: ($(window).width() - $(".modal-box").outerWidth()) / 2
            });
        });
        $(window).resize();
    }

    //////////////////
    $('.with-bg, .home-grid__mobile article, .team-list article figure .img').each(function(e) {
        var bg_ = 'url(' + $(this).find('> img').attr('src') + ')';
        $(this).find('> img').hide();
        $(this).css('background-image', bg_);
    });

    $('.no-backgroundsize .with-bg, .no-backgroundsize .home-grid__mobile article, .team-list article figure .img').each(function(e) {
        var bg_ = $(this).find('>img').attr('src');
        $(this).find('>img').hide();
        $(this).css({
            "filter" : "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+bg_+"', sizingMethod='scale')",
            "-ms-filter" : "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+bg_+"', sizingMethod='scale')"
        });
    });


    //////////////////
    $('.with-highlight').each(function(e) {
        $(this).append('<div class="item-highlight"></div>');
    });


    $(".custom-select").each(function(){
        var $class= $(this).attr('id');
        $(this).wrap("<span class='custom-select-wrap "+$class+"'></span>");
        $(this).after("<span class='holder'></span>");
    });

    $(".custom-select").change(function(){
        var selectedOption = $(this).find(":selected").text();
        $(this).next(".holder").text(selectedOption);
    }).trigger('change');


    setEqHeight();
    initModal();
    initMenuDropdown();

    $(window).on('resize', function(){
        setEqHeight();
    });
});

(function($){
    $('.progress-pie-chart').each(function (e) {
        var $ppc = $(this),
            percent = parseInt($ppc.data('percent')),
            deg = 360*percent/100;
        $ppc.append('<div class="ppc-progress"><div class="ppc-progress-fill"></div></div><div class="ppc-percents"><div class="pcc-percents-wrapper"><span></span></div></div>');
        if (percent > 50) {
            $ppc.addClass('gt-50');
        }
        $ppc.find('.ppc-progress-fill').css('transform','rotate('+ deg +'deg)');
        if(percent == 100) $ppc.find('.ppc-percents span').addClass('full');
    });
}(jQuery));

(function ($) {
    $('.i-checks-box').iCheck({
        checkboxClass: 'icheckbox_box',
        radioClass: 'iradio_box',
    });
    $('.selectpicker').selectpicker();
}(jQuery));