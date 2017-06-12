"use strict";

$(function () {

    function clickScroll() {
        $('.side-part .big')
            .click(function (e) {
                e.preventDefault();
                $('.big .highlight').removeClass('highlight');

                // console.log('scrollTo this:', this);
                $(this).addClass('highlight');

                var distanceTopToSection = $('#' + $(this).data('target'))
                    .offset()
                    .top;

                // console.log('this distanceTopToSection:', distanceTopToSection);

                $('.main-part').animate({
                    scrollTop: distanceTopToSection
                }, 'slow');
            });

        $('.side-part .small').click(function (e) {
            e.preventDefault();
            $('.side-center .small').removeClass('actived');

            // console.log('scrollTo this:', this);
            $(this).addClass('actived');

            var distanceTopToSection = $('#' + $(this).data('target'))
                .offset()
                .top;

            // console.log('this distanceTopToSection:', distanceTopToSection);

            $('.main-part').animate({
                scrollTop: distanceTopToSection
            }, 'slow');
        });

        $('.sidenav a').click(function (e) {
            e.preventDefault();

            // console.log('scrollTo this:', this);

            var distanceTopToSection = $('#' + $(this).data('target'))
                .offset()
                .top;

            // console.log('this distanceTopToSection:', distanceTopToSection);

            $('body').animate({
                scrollTop: distanceTopToSection
            }, 'slow');
        });
    }

    function scrollMenu() {
        var showBackTotop = $('.main-part').height();

        var side_center = $(".side-center").children();
        var tab = [];
        for (var i = 0; i < side_center.length; i++) {
            // console.log(side_center[i]);
            var child = side_center[i];
            var ahref = $(child).attr('href');
            // console.log(ahref);
            if (ahref) {
                tab.push(ahref);
            }
        }
        var side_right = $(".side-right").children();
        for (var i = 0; i < side_right.length; i++) {
            // console.log(side_right[i]);
            var child = side_right[i];
            var ahref = $(child).attr('href');
            // console.log(ahref);
            if (ahref) {
                tab.push(ahref);
            }
        }

        // console.log(tab);

        $('.main-part')
            .scroll(function () {
                var mainScrollTop = $('.main-part').scrollTop();
                var mainHeight = $('.main-part').height();
                var docHeight = $(document).height();

                for (var i = 0; i < tab.length; i++) {
                    var link = tab[i];
                    var divPos = $(link)
                        .offset()
                        .top;
                    var divHeight = $(link).height();
                    if (mainScrollTop >= divPos && mainScrollTop < (divPos + divHeight)) {
                        $(".side-part a[href='" + link + "'] .big").addClass("highlight");
                    } else {
                        $(".side-part a[href='" + link + "'] .big").removeClass("highlight");
                    }
                }

                if (mainScrollTop + mainHeight == docHeight) {
                    // console.log("mainScrollTop: ", mainScrollTop) console.log("mainHeight: ",
                    // mainHeight) console.log("pewpew docHeight:", docHeight)
                    if (!$(".side-part .side-center:last-child a").hasClass("highlight")) {
                        var navActive = $(".active").attr("href");
                        $(".side-part a[href='" + navActive + "']").removeClass("highlight");
                        $(".sdie-part .side-center:last-child a").addClass("highlight");
                    }
                }

                if (mainScrollTop == mainHeight) {
                    // console.log("mainScrollTop: ", mainScrollTop) console.log("mainHeight: ",
                    // mainHeight) console.log("heyhey docHeight:", docHeight)
                    if (!$(".side-part .side-center:last-child a").hasClass("actived")) {
                        var navActive = $(".actived").attr("href");
                        $(".side-part a[href='" + navActive + "']").removeClass("actived");
                        $(".sdie-part .side-center:last-child a").addClass("actived");
                    }
                }
            });

    }

    function scrollToTop() {
        var topBtn = $('.logo');
        $('.main-part').scroll(function () {
            if ($(this).scrollTop() > 300) {
                topBtn
                    .stop()
                    .animate({
                        'right': '20px'
                    }, 200, 'linear');
            } else {
                topBtn
                    .stop()
                    .animate({
                        'right': '-60px'
                    }, 200, 'linear');
            }
        });
        topBtn.bind('click', function (event) {
            event.preventDefault();
            $('.main-part')
                .stop()
                .animate({
                    'scrollTop': 0
                }, 1000, 'easeInQuart', function () {
                    topBtn
                        .stop()
                        .animate({
                            'right': '-60px'
                        }, 1000, 'easeInQuart');
                });
        });
    }

    function scrollToTopMobile() {
        var topBtnMobile = $('.logo-mobile');
        $('body').scroll(function () {
            // console.log('scrollToTopMobile')
            if ($(this).scrollTop() > 300) {
                topBtnMobile
                    .stop()
                    .animate({
                        'right': '20px'
                    }, 200, 'linear');
            } else {
                topBtnMobile
                    .stop()
                    .animate({
                        'right': '-60px'
                    }, 200, 'linear');
            }
        });
        topBtnMobile.bind('click', function (event) {
            event.preventDefault();
            $('body')
                .stop()
                .animate({
                    'scrollTop': 0
                }, 1000, 'easeInQuart', function () {
                    topBtnMobile
                        .stop()
                        .animate({
                            'right': '-60px'
                        }, 1000, 'easeInQuart');
                });
        });
    }

    function sideNavFn() {
        var openNav = $('.opennav');
        openNav.bind('click', function (event) {
            event.preventDefault();
            document
                .getElementById("sidenav")
                .style
                .width = "200px";
            openNav.fadeOut(300);
        });
        var closebtn = $('.closebtn');
        closebtn.bind('click', function (event) {
            event.preventDefault();
            document
                .getElementById("sidenav")
                .style
                .width = "0";
            openNav.fadeIn(300);
        });
    }

    function readMore(params) {
        var $readMore = $("#readMoreBtnText").text();
        var $readLess = $("#readLessBtnText").text();
        $("#readMoreBtn").text($readMore);
        $('#readMoreBtn').click(function () {
            var $this = $(this);
            // console.log($readMore);
            $("#readMoreBtn").text($readMore);
            if ($this.data('expanded') == "yes") {
                $this.data('expanded', "no");
                $("#readMoreBtn").text($readMore);
                $('#readMoreText').animate({height: '20em'});
                $('.readMoreGradient').show();
            } else {
                $this.data('expanded', "yes");
                $('#readMoreText').css({height: 'auto'});
                $("#readMoreBtn").text($readLess);
                $('.readMoreGradient').hide();

            }
        });
    }

    clickScroll();
    scrollMenu();
    scrollToTop();
    scrollToTopMobile();
    sideNavFn();
    readMore();

});