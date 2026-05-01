// 墨韵学社 - 主脚本

document.addEventListener('DOMContentLoaded', function() {
  // 移动端菜单切换
  const menuBtn = document.getElementById('mobileMenuBtn');
  const mainNav = document.getElementById('mainNav');

  if (menuBtn && mainNav) {
    menuBtn.addEventListener('click', function() {
      mainNav.classList.toggle('open');
      // 汉堡按钮动画
      const spans = menuBtn.querySelectorAll('span');
      menuBtn.classList.toggle('active');
      if (menuBtn.classList.contains('active')) {
        spans[0].style.transform = 'rotate(45deg) translate(5px, 5px)';
        spans[1].style.opacity = '0';
        spans[2].style.transform = 'rotate(-45deg) translate(5px, -5px)';
      } else {
        spans[0].style.transform = '';
        spans[1].style.opacity = '';
        spans[2].style.transform = '';
      }
    });

    // 点击导航链接后关闭菜单
    mainNav.querySelectorAll('.nav-link').forEach(function(link) {
      link.addEventListener('click', function() {
        mainNav.classList.remove('open');
        menuBtn.classList.remove('active');
        const spans = menuBtn.querySelectorAll('span');
        spans[0].style.transform = '';
        spans[1].style.opacity = '';
        spans[2].style.transform = '';
      });
    });
  }

  // 滚动时 Header 添加阴影
  const header = document.querySelector('.site-header');
  if (header) {
    window.addEventListener('scroll', function() {
      if (window.scrollY > 10) {
        header.style.boxShadow = '0 2px 8px rgba(0,0,0,0.08)';
      } else {
        header.style.boxShadow = '';
      }
    });
  }

  // 统计数字动画
  const statNumbers = document.querySelectorAll('.stat-number');
  if (statNumbers.length > 0) {
    const observer = new IntersectionObserver(function(entries) {
      entries.forEach(function(entry) {
        if (entry.isIntersecting) {
          const el = entry.target;
          const text = el.textContent;
          const match = text.match(/(\d[\d,]*)\+?/);
          if (match) {
            const target = parseInt(match[1].replace(/,/g, ''));
            const suffix = text.includes('+') ? '+' : '';
            animateNumber(el, 0, target, 1500, suffix);
          }
          observer.unobserve(el);
        }
      });
    }, { threshold: 0.5 });

    statNumbers.forEach(function(el) {
      observer.observe(el);
    });
  }

  // 卡片入场动画
  const cards = document.querySelectorAll('.essay-card, .feature-card');
  if (cards.length > 0) {
    const cardObserver = new IntersectionObserver(function(entries) {
      entries.forEach(function(entry) {
        if (entry.isIntersecting) {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateY(0)';
          cardObserver.unobserve(entry.target);
        }
      });
    }, { threshold: 0.1 });

    cards.forEach(function(card, index) {
      card.style.opacity = '0';
      card.style.transform = 'translateY(20px)';
      card.style.transition = 'opacity 0.5s ease ' + (index % 6) * 0.1 + 's, transform 0.5s ease ' + (index % 6) * 0.1 + 's';
      cardObserver.observe(card);
    });
  }
});

// 数字动画函数
function animateNumber(el, start, end, duration, suffix) {
  var startTime = null;
  function step(timestamp) {
    if (!startTime) startTime = timestamp;
    var progress = Math.min((timestamp - startTime) / duration, 1);
    // ease-out 缓动
    var eased = 1 - Math.pow(1 - progress, 3);
    var current = Math.floor(eased * (end - start) + start);
    el.textContent = current.toLocaleString() + suffix;
    if (progress < 1) {
      requestAnimationFrame(step);
    }
  }
  requestAnimationFrame(step);
}
