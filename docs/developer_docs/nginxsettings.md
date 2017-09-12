Role Name
=========

This role sets the settings for the ansible-nginx-role by jdauphant

Requirements
------------

This role only does a set_fact task.


Role Variables
--------------

variable | function
--- | ---
galaxy_docker_web_port | The internally exposed web port. Default: 8080
galaxy_public_web_port | The externally exposed web port. Default: 80
max_upload_size | specifies the maximum upload size. Default: 50g
galaxy_docker_web_urls | a list of web urls  (server aliases)

Dependencies
------------

-

Example Playbook
----------------

-
License
-------

A dual licensing mode is applied.
The source code within this project is freely available for non-commercial use under the GNU Affero General Public license.
For commercial users or users who do not want to follow the AGPL, please contact us to obtain a separate license.

You should have received a copy of the GNU Affero General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.

Author Information
------------------

Sequencing Analysis Support Core - Leiden University Medical Center
Contact us at: sasc@lumc.nl
