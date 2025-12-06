# HTML5 Ultra Pack Documentation

This documentation site is built with Jekyll and is designed to be hosted on GitHub Pages.

## Structure

- `_layouts/` - Contains the HTML templates for the site
- `_config.yml` - Jekyll configuration file
- `index.html` - Main landing page for the documentation
- Other `.md` files - Individual documentation pages

## Local Development

To run this documentation site locally:

1. Install Ruby and Jekyll:
   ```bash
   gem install jekyll bundler
   ```

2. Install dependencies:
   ```bash
   cd docs
   bundle install
   ```

3. Run the Jekyll server:
   ```bash
   bundle exec jekyll serve
   ```

4. Visit `http://localhost:4000` to view the site

## GitHub Pages Deployment

This site is configured to be deployed directly to GitHub Pages from the `docs` folder. When you push changes to the `main` branch, GitHub Pages will automatically build and deploy the site.

The site will be available at: `https://<username>.github.io/<repository>/docs/`

## Adding New Documentation

To add new documentation pages:

1. Create a new `.md` file in the `docs` folder
2. Add Jekyll front matter at the top of the file:
   ```yaml
   ---
   layout: page
   title: Your Page Title
   ---
   ```
3. Update the navigation in `_layouts/page.html` to include the new page