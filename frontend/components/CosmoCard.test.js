import { shallowMount } from '@vue/test-utils';
import CosmoCard from '@/components/CosmoCard.vue';

describe('CosmoCard', () => {
  it('renders the title and description correctly', () => {
    const title = 'Test Title';
    const description = 'Test Description';

    const wrapper = shallowMount(CosmoCard, {
      propsData: {
        title,
        description
      }
    });

    expect(wrapper.find('h2').text()).toBe(title);
    expect(wrapper.find('p').text()).toBe(description);
  });

  it('shows popover on mouseover and hides it on mouseleave', async () => {
    const wrapper = shallowMount(CosmoCard);

    expect(wrapper.find('.popover').exists()).toBe(false);

    await wrapper.trigger('mouseover');
    expect(wrapper.find('.popover').exists()).toBe(true);

    await wrapper.trigger('mouseleave');
    expect(wrapper.find('.popover').exists()).toBe(false);
  });

  it('applies the correct size class based on the prop', () => {
    const wrapper = shallowMount(CosmoCard, {
      propsData: {
        size: 'large'
      }
    });

    expect(wrapper.classes()).toContain('w-large');
  });

  it('applies the border class when the border prop is true', () => {
    const wrapper = shallowMount(CosmoCard, {
      propsData: {
        border: true
      }
    });

    expect(wrapper.classes()).toContain('border');
  });

  it('does not apply the border class when the border prop is false', () => {
    const wrapper = shallowMount(CosmoCard, {
      propsData: {
        border: false
      }
    });

    expect(wrapper.classes()).not.toContain('border');
  });
});
