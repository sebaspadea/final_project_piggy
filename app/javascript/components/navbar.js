const initUpdateNavbarOnScroll = () => {
  const navbar = document.querySelector('.navbar-lewagon');
  const burgerMenu = document.getElementById('burger-menu');
  if (navbar) {
    window.addEventListener('scroll', () => {
      if (window.scrollY >= 236) {
        navbar.classList.add('navbar-lewagon-white');
        burgerMenu.classList.remove("text-white");
        burgerMenu.classList.add("text-muted");
      } else {
        navbar.classList.remove('navbar-lewagon-white');
        burgerMenu.classList.add("text-white");
        burgerMenu.classList.remove("text-muted");
      }
    });
  }
}

export { initUpdateNavbarOnScroll };
