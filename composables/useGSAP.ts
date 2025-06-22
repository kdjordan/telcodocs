import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

export const useGSAP = () => {
  // Register ScrollTrigger plugin
  if (process.client) {
    gsap.registerPlugin(ScrollTrigger)
  }

  const animateHeroEntrance = () => {
    if (!process.client) return

    const tl = gsap.timeline()
    
    // Animate hero content from left
    tl.fromTo('.hero-content', 
      { 
        opacity: 0, 
        x: -100 
      },
      { 
        opacity: 1, 
        x: 0, 
        duration: 1.2, 
        ease: 'power3.out' 
      }
    )
    
    // Animate dashboard mockup from right
    tl.fromTo('.hero-dashboard', 
      { 
        opacity: 0, 
        x: 100, 
        scale: 0.9 
      },
      { 
        opacity: 1, 
        x: 0, 
        scale: 1, 
        duration: 1.2, 
        ease: 'power3.out' 
      }, 
      '-=0.8'
    )

    // Animate nav from top
    tl.fromTo('.hero-nav', 
      { 
        opacity: 0, 
        y: -50 
      },
      { 
        opacity: 1, 
        y: 0, 
        duration: 0.8, 
        ease: 'power2.out' 
      }, 
      '-=1.0'
    )

    return tl
  }

  const animateOnScroll = () => {
    if (!process.client) return

    // Animate sections on scroll
    gsap.utils.toArray('.animate-on-scroll').forEach((element: any) => {
      gsap.fromTo(element, 
        {
          opacity: 0,
          y: 50
        },
        {
          opacity: 1,
          y: 0,
          duration: 1,
          ease: 'power2.out',
          scrollTrigger: {
            trigger: element,
            start: 'top 80%',
            end: 'bottom 20%',
            toggleActions: 'play none none reverse'
          }
        }
      )
    })

    // Animate cards with stagger
    gsap.utils.toArray('.animate-cards').forEach((container: any) => {
      const cards = container.querySelectorAll('.card')
      
      gsap.fromTo(cards,
        {
          opacity: 0,
          y: 30,
          scale: 0.95
        },
        {
          opacity: 1,
          y: 0,
          scale: 1,
          duration: 0.8,
          ease: 'power2.out',
          stagger: 0.1,
          scrollTrigger: {
            trigger: container,
            start: 'top 75%',
            end: 'bottom 25%',
            toggleActions: 'play none none reverse'
          }
        }
      )
    })
  }

  const animateNavOnScroll = () => {
    if (!process.client) return

    ScrollTrigger.create({
      start: 'top -80',
      end: 99999,
      toggleClass: {
        className: 'nav-scrolled',
        targets: '.main-nav'
      }
    })
  }

  const cleanup = () => {
    if (!process.client) return
    ScrollTrigger.getAll().forEach(trigger => trigger.kill())
  }

  return {
    animateHeroEntrance,
    animateOnScroll,
    animateNavOnScroll,
    cleanup,
    gsap,
    ScrollTrigger
  }
}