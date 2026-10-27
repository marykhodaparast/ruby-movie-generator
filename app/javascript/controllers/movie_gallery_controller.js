import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    url: String,
  };

  connect() {
    this.loading = false;
    this.page = 2;
    this.observer = new IntersectionObserver(
      (entries) => {
        if (entries.some((entry) => entry.isIntersecting)) {
          this.loadNextPage();
        }
      },
      { rootMargin: "0px" },
    );

    this.observeSentinel();
  }

  disconnect() {
    this.observer?.disconnect();
  }

  observeSentinel() {
    const sentinel = this.element.querySelector(".gallery-load-more");

    if (sentinel) {
      this.observer.observe(sentinel);
    }
  }

  async loadNextPage() {
    if (this.loading) return;

    const sentinel = this.element.querySelector(".gallery-load-more");
    if (!sentinel) return;

    this.loading = true;
    this.observer.unobserve(sentinel);

    try {
      const url = new URL(this.urlValue, window.location.origin);
      url.searchParams.set("page", this.page);

      const response = await fetch(url, {
        headers: { Accept: "text/html" },
      });

      if (!response.ok) {
        throw new Error(`Request failed: ${response.status}`);
      }

      const html = await response.text();
      const template = document.createElement("template");
      template.innerHTML = html;

      const nextSentinel = template.content.querySelector(".gallery-load-more");
      const cards = Array.from(template.content.children).filter(
        (element) => !element.classList.contains("gallery-load-more"),
      );

      sentinel.replaceWith(...cards);

      if (nextSentinel) {
        this.element.appendChild(nextSentinel);
        this.page += 1;
        this.observer.observe(nextSentinel);
      }
    } catch (error) {
      console.error("Could not load more movies:", error);
    } finally {
      this.loading = false;
    }
  }
}
